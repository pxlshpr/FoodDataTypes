//import Foundation
//
//public struct SearchToken: Codable, Hashable, Equatable {
//    public var word: SearchWord
//    public var isPinned: Bool
//    
//    public init(word: SearchWord, isPinned: Bool) {
//        self.word = word
//        self.isPinned = isPinned
//    }
//}
//
//extension SearchToken: Identifiable {
//    public var id: UUID {
//        word.id
//    }
//}
//
//public extension Array where Element == SearchToken {
//    var flattened: [FlattenedSearchToken] {
//        self.map { FlattenedSearchToken(wordID: $0.word.id, isPinned: $0.isPinned) }
//    }
//}
