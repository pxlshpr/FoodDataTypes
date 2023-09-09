import Foundation
import CoreData

extension PublicStore {
    public static func words(
        matching text: String? = nil,
        page: Int
    ) async -> [SearchWord] {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                do {
                    try shared.container.words(
                        matching: text,
                        page: page
                    ) { words in
                        let results = words.map { $0.asSearchWord }
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


//MARK: Finding Words

extension PublicStore {
    
    public static func findWords(in text: String) async -> [FindWordResult] {
        
        let wordStrings = text
            .lowercased()
            .searchWords

        return await withTaskGroup(
            of: FindWordResult.self,
            returning: [FindWordResult].self
        ) { taskGroup in
            for string in wordStrings {
                taskGroup.addTask { await findWords(matching: string) }
            }

            return await taskGroup.reduce(into: [FindWordResult]()) { partialResult, results in
                partialResult.append(results)
            }
        }
    }
    
    static func findWords(matching text: String) async -> FindWordResult {
        let words = SearchWordEntity.findWords(matching: text, context: newBackgroundContext())
            .map { $0.asSearchWord }
        if words.isEmpty {
            return FindWordResult(words: nil, string: text)
        } else {
            return FindWordResult(words: words, string: nil)
        }
    }
}
