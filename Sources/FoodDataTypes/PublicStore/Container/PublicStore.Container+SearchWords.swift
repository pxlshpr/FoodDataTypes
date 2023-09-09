import Foundation

extension PublicStore.Container {
    
    func words(
        matching text: String? = nil,
        page: Int,
        completion: @escaping (([SearchWordEntity]) -> ())
    ) throws {
        Task {
            let bgContext = newBackgroundContext()
            await bgContext.perform {
                let entities = SearchWordEntity.fetch(matching: text, page: page, context: bgContext)
                completion(entities)
            }
        }
    }
}
