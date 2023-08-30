import Foundation

private let SearchTokenPropertySeparator = " | "

public struct SearchToken: Codable {
    public var word: SearchWord
    public var rank: Int
    
    public init(word: SearchWord, rank: Int) {
        self.word = word
        self.rank = rank
    }
    
    public init?(from string: String) {
        let components = string.components(separatedBy: SearchTokenPropertySeparator)
        guard 
            components.count == 2,
            let word = SearchWord(from: components[0]),
            let rank = Int(components[1])
        else { return nil }
        
        self.init(word: word, rank: rank)
    }
    
    public var asString: String {
        word.asString
        + SearchTokenPropertySeparator
        + "\(rank)"
    }
}
