//import Foundation
//
//public let FlattenedSearchTokenSeparator = " | "
//private let FlattenedSearchTokenPropertySeparator = " "
//
//public struct FlattenedSearchToken: Codable, Hashable, Equatable {
//    public var wordID: UUID
//    public var isPinned: Bool
//    
//    public init(wordID: UUID, isPinned: Bool) {
//        self.wordID = wordID
//        self.isPinned = isPinned
//    }
//    
//    public init?(from string: String) {
//        let components = string.components(separatedBy: FlattenedSearchTokenPropertySeparator)
//        guard
//            components.count == 2,
//            let wordID = UUID(uuidString: components[0]),
//            let isPinnedInt = Int(components[1])
//        else { return nil }
//        
//        self.init(wordID: wordID, isPinned: isPinnedInt == 1)
//    }
//    
//    public var asString: String {
//        wordID.uuidString
//        + FlattenedSearchTokenPropertySeparator
//        + "\(isPinned ? 1 : 0)"
//    }
//}
//
//extension FlattenedSearchToken: Identifiable {
//    public var id: UUID {
//        wordID
//    }
//}
//
//public extension String {
//    var searchTokens: [FlattenedSearchToken] {
//        guard !isEmpty else { return [] }
//        return self
//            .components(separatedBy: FlattenedSearchTokenSeparator)
//            .compactMap { FlattenedSearchToken(from: $0) }
//    }
//}
//
//public extension Array where Element == FlattenedSearchToken {
//    var asString: String {
//        self
//            .map { $0.asString }
//            .joined(separator: FlattenedSearchTokenSeparator)
//    }
//}
