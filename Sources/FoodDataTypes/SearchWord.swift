import Foundation

private let SearchWordPropertySeparator = " ¦ "
private let SearchWordSpellingSeparator = " , "

public struct SearchWord: Identifiable, Codable, Hashable, Equatable {
    public let id: UUID
    public var singular: String
    public var spellings: [String]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        singular: String,
        spellings: [String],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.singular = singular
        self.spellings = spellings
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public init?(from string: String) {
        let components = string.components(separatedBy: SearchWordPropertySeparator)
        guard components.count == 2 else { return nil }
        let singular = components[0]
        let spellings = components[1]
            .components(separatedBy: SearchWordSpellingSeparator)
        
        /// If any word contains spaces, fail and return nil
        guard !singular.contains(" "),
              !spellings.contains(where: { $0.contains(" ")})
        else {
            return nil
        }
        
        self.init(singular: singular, spellings: spellings)
    }

    public var asString: String {
        singular
        + SearchWordPropertySeparator
        + spellings.joined(separator: SearchWordSpellingSeparator)
    }
}
