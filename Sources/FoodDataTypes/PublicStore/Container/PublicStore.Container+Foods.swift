import Foundation

extension PublicStore.Container {
    
    func searchFoods(
        _ wordResults: [FindWordResult],
//        _ unrecognizedWords: [String],
//        _ wordIDs: [UUID],
        _ page: Int,
        completion: @escaping (([DatasetFoodEntity]) -> ())
    ) throws {
        Task {
            let bgContext = newBackgroundContext()
            await bgContext.perform {
                let predicate = searchFoodsPredicate(wordResults)
                let sortDescriptors = [
//                    NSSortDescriptor(keyPath: \DatasetFoodEntity.isRaw, ascending: false),
//                    NSSortDescriptor(keyPath: \DatasetFoodEntity.lastUsedAt, ascending: false),
                    NSSortDescriptor(keyPath: \DatasetFoodEntity.name, ascending: true)
                ]
                
                let results = DatasetFoodEntity.objects(
                    predicate: predicate,
                    sortDescriptors: sortDescriptors,
                    fetchLimit: FoodsPageSize,
                    fetchOffset: (page - 1) * FoodsPageSize,
                    context: bgContext
                )
                
                completion(results)
            }
        }
    }
    
    func fetchFoodsMatching(
        _ fields: SearchWordFields,
        completion: @escaping (([DatasetFoodEntity]) -> ())
    ) throws {
        Task {
            let bgContext = newBackgroundContext()
            await bgContext.perform {
                let predicate = wordFormFoodsPredicate(fields)
                let sortDescriptors = [
//                    NSSortDescriptor(keyPath: \DatasetFoodEntity.isRaw, ascending: false),
//                    NSSortDescriptor(keyPath: \DatasetFoodEntity.lastUsedAt, ascending: false),
                    NSSortDescriptor(keyPath: \DatasetFoodEntity.name, ascending: true)
                ]
                
                let results = DatasetFoodEntity.objects(
                    predicate: predicate,
                    sortDescriptors: sortDescriptors,
                    context: bgContext
                )
                
                completion(results)
            }
        }
    }
}
