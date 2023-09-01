import Foundation

public struct SearchToken: Codable, Hashable, Equatable {
    public var word: SearchWord
    public var rank: Int
    
    public init(word: SearchWord, rank: Int) {
        self.word = word
        self.rank = rank
    }
}

extension SearchToken: Identifiable {
    public var id: UUID {
        word.id
    }
}

public extension Array where Element == SearchToken {
    var flattened: [FlattenedSearchToken] {
        self.map { FlattenedSearchToken(wordID: $0.word.id, rank: $0.rank) }
    }
}
