import Foundation
import CoreData
import CloudKit

extension PublicStore {
    
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
    
    func fetchVerifiedFoods(_ context: NSManagedObjectContext) async throws -> Date? {
        func persist(record: CKRecord) {
            @Sendable
            func performChanges() {
                if let existing = VerifiedFoodEntity.object(with: record.id!, in: context) {
                    //TODO: Do this
//                    existing.merge(with: record, context: context)
                } else {
//                    let entity = VerifiedFoodEntity(record, context)
//                    context.insert(entity)
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
