import Foundation

extension PublicStore {
    
    func searchFoods(
        _ wordResults: [FindWordResult],
//        _ unrecognizedWords: [String],
//        _ wordIDs: [UUID],
        _ page: Int
    ) async -> [Food] {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                do {
                    try container.searchFoods(wordResults, page) { foods in
                        let results = foods.map { Food($0) }
                        continuation.resume(returning: results)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        } catch {
            return []
        }
    }
    
    public func fetchFoodsMatching(_ fields: SearchWordFields) async -> [Food] {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                do {
                    try container.fetchFoodsMatching(fields) { foods in
                        let results = foods.map { Food($0) }
                        continuation.resume(returning: results)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        } catch {
            return []
        }
    }
}
