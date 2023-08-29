import Foundation

private let SearchWordPropertySeparator = "¦"
private let SearchWordMisspellingSeparator = ","

public struct SearchWord: Codable {
    public var singular: String
    public var plural: String
    public var misspellings: [String]
    
    public init(singular: String, plural: String, misspellings: [String]) {
        self.singular = singular
        self.plural = plural
        self.misspellings = misspellings
    }
}
