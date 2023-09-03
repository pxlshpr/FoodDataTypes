import Foundation

public struct SearchToken: Codable, Hashable, Equatable {
    public var word: SearchWord
    public var rank: SearchRank
    
    public init(word: SearchWord, rank: SearchRank) {
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
