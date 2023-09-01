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
