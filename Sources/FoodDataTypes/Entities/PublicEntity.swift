import Foundation
import CoreData
import CloudKit

public protocol PublicEntity: Entity {
    var updatedAt: Date? { get set }
    var isSynced: Bool { get set }

    static var recordType: RecordType { get }
    static var notificationName: Notification.Name { get }

    static func object(matching record: CKRecord, context: NSManagedObjectContext) -> NSManagedObject?
    func fill(with record: CKRecord)
    func merge(with record: CKRecord, context: NSManagedObjectContext)
}

public extension PublicEntity {
    func setAsUpdated() {
        self.updatedAt = Date.now
        self.isSynced = false
    }
    
    func isLessRecent(than record: CKRecord) -> Bool {
        /// Always favour the CloudKit record when we have a timestamp missing
        guard let updatedAt = self.updatedAt else { return true }
        guard let recordUpdatedAt = record.updatedAt else { return true }
        
        return recordUpdatedAt > updatedAt
    }
    
    func merge(with record: CKRecord, context: NSManagedObjectContext) {
        /// Make sure the record is more recent than this version
        guard isLessRecent(than: record) else {
            /// If our version is more recent then we retain any changes we may have made, which will be
            /// subsequently uploaded during the sync.
            return
        }
        /// Use all its values (that could have possibly changed), discarding our changes and resetting `isSynced` to `false`
        fill(with: record)
        isSynced = true
    }
    
    static func fetchAndPersistUpdatedRecords(
        _ context: NSManagedObjectContext,
        _ desiredKeys: [CKRecord.FieldKey]?
    ) async throws -> Date? {
        func persistHandler(record: CKRecord) {
            @Sendable
            func performChanges() {
                if let existing = Self.object(matching: record, context: context) as? Self {
                    existing.merge(with: record, context: context)
                } else {
                    let entity = Self(context: context)
                    entity.fill(with: record)
                    entity.isSynced = true
                    context.insert(entity)
                }
            }
            
            Task {
                await context.performInBackgroundAndMergeWithMainContext(
                    mainContext: PublicStore.mainContext,
                    posting: notificationName,
                    performBlock: performChanges
                )
            }
        }
        
        return try await fetchUpdatedRecords(recordType, desiredKeys, context, persistHandler)
    }
}
