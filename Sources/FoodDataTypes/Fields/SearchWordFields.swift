import Foundation

public struct SearchWordFields: Hashable, Equatable {
    public var singular: String = ""
    public var spellings: [String] = []
}

public extension SearchWordFields {
    
    var canBeSaved: Bool {
        !singular.isEmpty
    }
    
    mutating func sanitize() {
        singular = singular.sanitizedSearchWord()
        spellings = spellings.map { $0.sanitizedSearchWord() }
    }
    
    mutating func fill(with word: SearchWord) {
        singular = word.singular
        spellings = word.spellings
    }
}
