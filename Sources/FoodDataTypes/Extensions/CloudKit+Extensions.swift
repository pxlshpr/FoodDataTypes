import Foundation
import CloudKit

public let PublicDatabase = CKContainer.prepPublicDatabase

public extension CKQuery {
    static func updatedRecords(of recordType: RecordType) -> CKQuery {
        CKQuery(recordType: recordType.name, predicate: .recordsToDownload)
    }
    
    static func fetchRecord(id: UUID, recordType: RecordType) -> CKQuery {
        CKQuery(recordType: recordType.name, predicate: .record(with: id))
    }
}

public extension CKContainer {
    static var prepContainer: CKContainer {
        CKContainer(identifier: "iCloud.com.ahmdrghb.Prep")
    }
    static var prepPublicDatabase: CKDatabase {
        prepContainer.publicCloudDatabase
    }
}

public extension CKDatabase {

    func record(id: UUID, recordType: RecordType) async throws -> CKRecord? {
        do {
            let query = CKQuery.fetchRecord(id: id, recordType: recordType)
            return try await record(matching: query)
        } catch let error as CKError {
            if error.code == .unknownItem {
                return nil
            } else {
                throw error
            }
        } catch {
            throw error
        }
    }

    func searchWords(containing string: String) async throws -> [CKRecord] {
        do {
            let query = CKQuery(
                recordType: RecordType.searchWord.name,
                predicate: NSPredicate(format: "self contains %@", string)
            )
            return try await records(matching: query)
        } catch let error as CKError {
            if error.code == .unknownItem {
                return []
            } else {
                throw error
            }
        } catch {
            throw error
        }

    }
    
    func findSearchWord(withSingular singular: String) async throws -> CKRecord? {
        /// Get the records containing the `singular` string (this uses a `self contains` predicate in CloudKit,
        /// so the results could have the word in any field (including the spellings array)
        let records = try await searchWords(containing: singular)

        /// Return the first having the same `singular` string
        return records.first(where: {
            $0.singular!.compare(singular, options: .diacriticInsensitive) == .orderedSame
        })
    }

    func record(matching searchWord: SearchWord) async throws -> CKRecord? {
        if let record = try await record(id: searchWord.id, recordType: .searchWord) {
            return record
        }
    
        if let record = try await findSearchWord(withSingular: searchWord.singular) {
            return record
        }
        
        return nil
    }

    func records(matching query: CKQuery) async throws -> [CKRecord] {
        do {
            let (results, _) = try await PublicDatabase.records(matching: query)
            return results.compactMap {
                switch $0.1 {
                case .failure(let error):
                    PublicStore.logger.error("Error fetching record: \(error.localizedDescription)")
                    return nil
                case .success(let record):
                    return record
                }
            }
        } catch let error as CKError {
            if error.code == .unknownItem {
                return []
            } else {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func record(matching query: CKQuery) async throws -> CKRecord? {
        try await records(matching: query).first
    }
    
//    func saveRecord(_ record: CKRecord) async -> Bool {
//        await withCheckedContinuation { continuation in
//            saveRecord(record) { success in
//                continuation.resume(returning: success)
//            }
//        }
//    }
//
//    func saveRecord(
//        _ record: CKRecord,
//        completion: @escaping ((Bool) -> ())
//    ) {
//        save(record) { record, error in
//            if let error = error {
//                completion(false)
//            } else {
//                completion(true)
//            }
//        }
//    }
}

public extension NSPredicate {
    static var recordsToDownload: NSPredicate {
        if let latestModificationDate {
//            /// Always fetch records with a 15 minute buffer from the last fetched record's modification date to allow for CloudKit's indexing to complete
//            let date = latestModificationDate.addingTimeInterval(-60 * 15)
            let date = latestModificationDate.addingTimeInterval(0.001)
            PublicStore.logger.debug("Getting records after: \(date)")
            let predicate = NSPredicate(format: "modificationDate > %@", date as NSDate)
            return predicate
        } else {
            return NSPredicate(format: "TRUEPREDICATE")
        }
    }
    
    static func record(with id: UUID) -> NSPredicate {
        NSPredicate(format: "id == %@", id.uuidString)
    }
}
