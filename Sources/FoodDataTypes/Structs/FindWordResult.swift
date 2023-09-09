import Foundation

public struct FindWordResult {
    public let words: [SearchWord]?
    public let string: String?
    
    public init(words: [SearchWord]?, string: String?) {
        self.words = words
        self.string = string
    }
}

public extension Array where Element == FindWordResult {
    var unrecognizedWords: [String] {
        self.compactMap { $0.string }
    }
    
    var allWordIDs: [UUID] {
        self.compactMap { $0.words }
            .reduce([]) { wordIDs, array in
                wordIDs + array.reduce([], { partialResult, word in
                    partialResult + [word.id]
                })
            }
    }
    
    var wordIDArrays: [[UUID]] {
        self.compactMap {
            guard let words = $0.words else { return nil }
            return words.map { $0.id }
        }
    }
}
