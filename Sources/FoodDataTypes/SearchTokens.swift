import Foundation

private let SearchTokenSeparator = " ; "

public struct SearchTokens: Codable {
    public var tokens: [SearchToken]
    
    public init(tokens: [SearchToken]) {
        self.tokens = tokens
    }
    
    public init(from string: String) {
        let tokens = string
            .components(separatedBy: SearchTokenSeparator)
            .compactMap { SearchToken(from: $0) }
        self.init(tokens: tokens)
    }
    
    public var asString: String {
        tokens
            .map { $0.asString }
            .joined(separator: SearchTokenSeparator)
    }
}
