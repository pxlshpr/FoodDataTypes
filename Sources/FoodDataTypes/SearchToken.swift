import Foundation

private let SearchTokenPropertySeparator = "|"
private let SearchTokenSeparator = ";"

public struct SearchToken: Codable {
    public var word: SearchWord
    public var rank: Int
    
    public init(word: SearchWord, rank: Int) {
        self.word = word
        self.rank = rank
    }
}
