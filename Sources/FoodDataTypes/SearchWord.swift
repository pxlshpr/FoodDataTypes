import Foundation

private let SearchWordPropertySeparator = " ¦ "
private let SearchWordMisspellingSeparator = " , "

public struct SearchWord: Codable {
    public var singular: String
    public var plural: String
    public var misspellings: [String]
    
    public init(singular: String, plural: String, misspellings: [String]) {
        self.singular = singular
        self.plural = plural
        self.misspellings = misspellings
    }
    
    public init?(from string: String) {
        let components = string.components(separatedBy: SearchWordPropertySeparator)
        guard components.count == 3 else { return nil }
        let singular = components[0]
        let plural = components[1]
        let misspellings = components[2]
            .components(separatedBy: SearchWordMisspellingSeparator)
        
        /// If any word contains spaces, fail and return nil
        guard !singular.contains(" "),
              !plural.contains(" "),
              !misspellings.contains(where: { $0.contains(" ")})
        else {
            return nil
        }
        
        self.init(singular: singular, plural: plural, misspellings: misspellings)
    }

    public var asString: String {
        singular
        + SearchWordPropertySeparator
        + plural
        + SearchWordPropertySeparator
        + misspellings.joined(separator: SearchWordMisspellingSeparator)
    }
}
