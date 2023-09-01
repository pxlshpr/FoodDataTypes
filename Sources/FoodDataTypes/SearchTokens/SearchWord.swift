import Foundation

public let SearchWordIDSeparator = " "

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
}

public extension String {
    var searchWordIDs: [UUID] {
        guard !isEmpty else { return [] }
        return self
            .components(separatedBy: SearchWordIDSeparator)
            .compactMap { UUID(uuidString: $0) }
    }
}

public extension Array where Element == UUID {
    var asString: String {
        self
            .map { $0.uuidString }
            .joined(separator: SearchWordIDSeparator)
    }
}
