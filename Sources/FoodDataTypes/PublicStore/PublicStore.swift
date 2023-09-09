import Foundation
import CoreData
import CloudKit
import OSLog

import Zip

private let overviewLogger = Logger(subsystem: "PublicBackend", category: "Overview")
private let syncSleep: Double = 3
let PresetModifiedDate = Date(timeIntervalSince1970: 1693936840)

@Observable public class PublicStore {
    
    static let shared = PublicStore()
    
    let container: Container

    let logger = Logger(subsystem: "PublicBackend", category: "")
    public static var logger: Logger { shared.logger }
    
    var uploadTask: Task<Void, Error>? = nil
    var fetchTask: Task<Void, Error>? = nil
    var shouldUpdateVersion: Bool = false

    public convenience init() {
        self.init(container: Container())
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    init(container: Container) {
        self.container = container
        setupSubscription()
    }

    public static var mainContext: NSManagedObjectContext {
        shared.container.viewContext
    }
    
    public static func newBackgroundContext() -> NSManagedObjectContext {
        shared.container.newBackgroundContext()
    }
}

public extension PublicStore {
    static func populateIfEmpty() {
        let start = CFAbsoluteTimeGetCurrent()
        var count = DatasetFoodEntity.countAll(in: shared.container.viewContext)
        guard count == 0 else {
            logger.debug("Not populating DatasetFoods")
            return
        }
        
        let zipURL = Bundle.main.url(forResource: "DatasetFoods", withExtension: "zip")!
        let unzipURL = try! Zip.quickUnzipFile(zipURL)
        let sqliteURL = unzipURL.appending(path: "DatasetFoods.sqlite")

        shared.replacePersisteStore(with: sqliteURL)

        /// Remove unzipped folder as we don't need these any more
        try! FileManager.default.removeItem(at: unzipURL)

        count = DatasetFoodEntity.countAll(in: shared.container.viewContext)
        logger.debug("Populated \(count) DatasetFoods in \(CFAbsoluteTimeGetCurrent()-start)s")
    }
    
    func replacePersisteStore(with url: URL) {
        container.replacePersisteStore(with: url)
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Failed to load CoreData: \(error)")
            }
        }
    }
}

//MARK: Syncer
import SwiftSugar

extension PublicStore {
    public static func startUploadPoller() {
        /// Set the preopulated `latestModificationDate` time if we have no version set (to ensure we don't redundantly download those entities)
        if latestModificationDate == nil {
            setLatestModificationDate(PresetModifiedDate)
        }
        
        shared.startUploadPoller()
    }
    
    func startUploadPoller() {
        uploadTask?.cancel()
        uploadTask = Task.detached(priority: .medium) {
            while true {
                await self.uploadChanges()
                try await sleepTask(syncSleep, tolerance: 1)
                try Task.checkCancellation()
            }
        }
    }

    public static func fetchChanges() {
        shared.fetchChanges()
    }
    
    func fetchChanges() {
        fetchTask?.cancel()
        fetchTask = Task.detached(priority: .medium) {
            await self.fetchChanges()
        }
    }
    
    private func fetchChanges() async {
        let context = PublicStore.newBackgroundContext()
        do {
            let wordsDate = try await fetchSearchWords(context)
            try Task.checkCancellation()
            let foodsDate = try await fetchDatasetFoods(context)
            
            if let latestDate = [wordsDate, foodsDate].latestDate {
                setLatestModificationDate(latestDate)
            }
        } catch {
            logger.error("Error during download: \(error.localizedDescription)")
        }
    }
    
    func uploadChanges() async {
        let context = PublicStore.newBackgroundContext()
        do {
            try await uploadSearchWords(context)
            try await uploadDatasetFoods(context)
        } catch {
            logger.error("Error during upload: \(error.localizedDescription)")
        }
    }
}

extension PublicStore {
    
    func uploadSearchWords(_ context: NSManagedObjectContext) async throws {
        
        func updatedOrCreatedRecord(for entity: SearchWordEntity) async throws -> CKRecord? {
            /// First try and fetch the existing record for the id
            if let existingRecord = try await PublicDatabase.record(matching: entity.asSearchWord) {
                /// If it was fetched, first do a sanity check and ensure our `updatedAt` time is more recent (in case changes occurred and were synced between the download and upload calls during the sync)
                guard entity.updatedAt! > existingRecord.updatedAt! else {
                    /// Otherwise merging the CloudKit copy and abandoning our changes
                    await context.performInBackgroundAndMergeWithMainContext(
                        mainContext: PublicStore.mainContext
                    ) {
                        entity.merge(with: existingRecord, context: context)
                        entity.isSynced = true
                    }
                    return nil
                }
                
                let previousID = entity.id!

                /// If our copy is in fact more recent, update the fetched record with it
                existingRecord.update(withSearchWordEntity: entity)
                
                await context.performInBackgroundAndMergeWithMainContext(
                    mainContext: PublicStore.mainContext
                ) {
                    /// Replace the ID in any entities that may have used the old ID if it's different to what we have
                    if previousID != existingRecord.id {
                        DatasetFoodEntity.replaceWordID(previousID, with: existingRecord.id!, context: context)
                    }
                }
                
                return existingRecord
                
            } else {
                /// Otherwise, create a new record using `.asCKRecord`
                return entity.asCKRecord
            }
        }
        
        let entities = SearchWordEntity.objects(
            predicateFormat: "isSynced == NO",
            context: context
        )

        logger.debug("We have: \(entities.count) words to upload")
        
        for entity in entities {
            guard let record = try await updatedOrCreatedRecord(for: entity) else {
                continue
            }
            
            /// Now call the `CKDatabase.save()` function
            try await PublicDatabase.save(record)
            
            await context.performInBackgroundAndMergeWithMainContext(
                mainContext: PublicStore.mainContext
            ) {
                /// Once saved, set isSynced to `true`
                entity.isSynced = true
            }
        }
    }
    
    func uploadDatasetFoods(_ context: NSManagedObjectContext) async throws {
        
        func updatedOrCreatedRecord(for entity: DatasetFoodEntity) async throws -> CKRecord? {
            /// First try and fetch the existing record for the id
            if let existingRecord = try await PublicDatabase.record(id: entity.id!, recordType: .datasetFood) {
                /// If it was fetched, first do a sanity check and ensure our `updatedAt` time is more recent (in case changes occurred and were synced between the download and upload calls during the sync)
                guard entity.updatedAt! > existingRecord.updatedAt! else {
                    /// Otherwise merging the CloudKit copy and abandoning our changes
                    await context.performInBackgroundAndMergeWithMainContext(
                        mainContext: PublicStore.mainContext
                    ) {
                        entity.merge(with: existingRecord, context: context)
                        entity.isSynced = true
                    }
                    return nil
                }
                
                /// If our copy is in fact more recent, update the fetched record with it
                existingRecord.update(withDatasetFoodEntity: entity)
                
                return existingRecord
                
            } else {
                /// Otherwise, create a new `CKRecord` (not supported yet)
                fatalError()
            }
        }
        
        let entities = DatasetFoodEntity.objects(
            predicateFormat: "isSynced == NO",
            context: context
        )
        logger.debug("We have: \(entities.count) foods to upload")

        for entity in entities {
            guard let record = try await updatedOrCreatedRecord(for: entity) else {
                continue
            }
            
            /// Now call the `CKDatabase.save()` function
            try await PublicDatabase.save(record)
            
            await context.performInBackgroundAndMergeWithMainContext(
                mainContext: PublicStore.mainContext
            ) {
                /// Once saved, set isSynced to `true`
                entity.isSynced = true
            }
        }
    }
}

//MARK: - Download

extension PublicStore {

    func fetchSearchWords(_ context: NSManagedObjectContext) async throws -> Date? {
        
        func persist(record: CKRecord) {
            
            @Sendable
            func performChanges() {
                if let existing = SearchWordEntity.existingWord(matching: record, context: context) {
                    existing.merge(with: record, context: context)
                } else {
                    let entity = SearchWordEntity(record, context)
                    context.insert(entity)
                }
            }
            
            Task {
                await context.performInBackgroundAndMergeWithMainContext(
                    mainContext: PublicStore.mainContext,
                    posting: .didUpdateWord,
                    performBlock: performChanges
                )
            }
        }
        
        return try await fetchUpdatedRecords(.searchWord, context, persist)
    }
    
    func fetchDatasetFoods(_ context: NSManagedObjectContext) async throws -> Date? {
        
        func persist(record: CKRecord) {
            
            @Sendable
            func performChanges() {
                if let existing = DatasetFoodEntity.object(with: record.id!, in: context) {
                    existing.merge(with: record, context: context)
                } else {
                    let entity = DatasetFoodEntity(record, context)
                    context.insert(entity)
                }
            }
            
            Task {
                await context.performInBackgroundAndMergeWithMainContext(
                    mainContext: PublicStore.mainContext,
                    posting: .didUpdateFood,
                    performBlock: performChanges
                )
            }
        }
        
        return try await fetchUpdatedRecords(.datasetFood, context, persist)
    }
}

extension PublicStore {
    
    func fetchUpdatedRecords(
        _ type: RecordType,
        _ context: NSManagedObjectContext,
        _ persistRecordHandler: @escaping (CKRecord) -> ()
    ) async throws -> Date? {
        
        var latestModificationDate: Date? = nil
        
        func processRecords(for query: CKQuery? = nil, continuing cursor: CKQueryOperation.Cursor? = nil) async throws {
            do {
                let (results, cursor) = if let query {
                    try await PublicDatabase.records(matching: query)
                } else {
                    try await PublicDatabase.records(continuingMatchFrom: cursor!)
                }
                
                logger.debug("Fetched \(results.count) records")
                
                latestModificationDate = results.latestModificationDate(ifAfter: latestModificationDate)
                
                if !results.isEmpty { shouldUpdateVersion = true }
                for result in results {
                    switch result.1 {
                    case .success(let record):
                        persistRecordHandler(record)
                    case .failure(let error):
                        throw error
                    }
                }
                
                if let cursor {
                    logger.info("Received a cursor, running a new query with that")
                    try await processRecords(continuing: cursor)
                } else {
                    logger.info("✅ Looks like we're done with a lastModifiedDate of: \(String(describing: latestModificationDate))")
                }
                
            } catch let error as CKError {
                if error.code == .unknownItem {
                    logger.info("Fetch failed with unknownItem error, treating as success")
                } else {
                    throw error
                }
            } catch {
                throw error
            }
        }
        
        let query = CKQuery.updatedRecords(of: type)
        try await processRecords(for: query)
        return latestModificationDate
    }
}

extension Array where Element == CKRecord {
    var latestModifiedDate: Date? {
        self.compactMap { $0.modificationDate }
            .sorted()
            .last
    }
}

extension Array where Element == (CKRecord.ID, Result<CKRecord, Error>) {
    var records: [CKRecord] {
        self.compactMap {
            switch $0.1 {
            case .success(let record):
                return record
            case .failure:
                return nil
            }
        }
    }
    
    func latestModificationDate(ifAfter date: Date?) -> Date? {
        guard let latestModificationDate = records.latestModifiedDate else {
            return date
        }
        guard let date else { return latestModificationDate }
        return latestModificationDate > date ? latestModificationDate : date
    }
}
