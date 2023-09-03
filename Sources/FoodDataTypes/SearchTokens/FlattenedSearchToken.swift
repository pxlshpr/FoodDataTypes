import Foundation

public let FlattenedSearchTokenSeparator = " | "
private let FlattenedSearchTokenPropertySeparator = " "

public struct FlattenedSearchToken: Codable, Hashable, Equatable {
    public var wordID: UUID
    public var rank: SearchRank
    
    public init(wordID: UUID, rank: SearchRank) {
        self.wordID = wordID
        self.rank = rank
    }
    
    public init?(from string: String) {
        let components = string.components(separatedBy: FlattenedSearchTokenPropertySeparator)
        guard
            components.count == 2,
            let wordID = UUID(uuidString: components[0]),
            let rankValue = Int(components[1]),
            let rank = SearchRank(rawValue: rankValue)
        else { return nil }
        
        self.init(wordID: wordID, rank: rank)
    }
    
    public var asString: String {
        wordID.uuidString
        + FlattenedSearchTokenPropertySeparator
        + "\(rank.rawValue)"
    }
}

extension FlattenedSearchToken: Identifiable {
    public var id: UUID {
        wordID
    }
}

public extension String {
    var searchTokens: [FlattenedSearchToken] {
        guard !isEmpty else { return [] }
        return self
            .components(separatedBy: FlattenedSearchTokenSeparator)
            .compactMap { FlattenedSearchToken(from: $0) }
    }
}

public extension Array where Element == FlattenedSearchToken {
    var asString: String {
        self
            .map { $0.asString }
            .joined(separator: FlattenedSearchTokenSeparator)
    }
}
