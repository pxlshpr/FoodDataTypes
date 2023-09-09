import Foundation
import CoreData
import CloudKit

extension PublicStore {
    
//    func fetchDatasetFoods(_ context: NSManagedObjectContext) async throws -> Date? {
//        func persist(record: CKRecord) {
//            @Sendable
//            func performChanges() {
//                if let existing = DatasetFoodEntity.object(with: record.id!, in: context) {
//                    existing.merge(with: record, context: context)
//                } else {
//                    let entity = DatasetFoodEntity(context: context)
//                    entity.sync(with: record)
//                    context.insert(entity)
//                }
//            }
//            
//            Task {
//                await context.performInBackgroundAndMergeWithMainContext(
//                    mainContext: PublicStore.mainContext,
//                    posting: .didUpdateFood,
//                    performBlock: performChanges
//                )
//            }
//        }
//        
//        return try await fetchUpdatedRecords(.datasetFood, context, persist)
//    }
    
//    func fetchSearchWords(_ context: NSManagedObjectContext) async throws -> Date? {
//        
//        func persist(record: CKRecord) {
//            
//            @Sendable
//            func performChanges() {
//                if let existing = SearchWordEntity.existingWord(matching: record, context: context) {
//                    existing.merge(with: record, context: context)
//                } else {
//                    let entity = SearchWordEntity(record, context)
//                    context.insert(entity)
//                }
//            }
//            
//            Task {
//                await context.performInBackgroundAndMergeWithMainContext(
//                    mainContext: PublicStore.mainContext,
//                    posting: .didUpdateWord,
//                    performBlock: performChanges
//                )
//            }
//        }
//        
//        return try await fetchUpdatedRecords(.searchWord, context, persist)
//    }
}
