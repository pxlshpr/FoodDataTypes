import Foundation

public enum SearchRank: Int, Codable, CaseIterable {
    case none       = -1
    case low        = 0
    case standard   = 1
    case high       = 2
    case higher     = 3
    case highest    = 4
}

public extension SearchRank {
    static var allPriorities: [SearchRank] {
        [.low, .standard, .high, .higher, .highest]
    }

    var menuDescription: String {
        switch self {
        case .none:     "Remove"
        case .low:      "Low"
        case .standard: "Standard"
        case .high:     "High"
        case .higher:   "Higher"
        case .highest:  "Highest"
        }
    }
    
    var description: String {
        switch self {
        case .none:     "Not Included"
        case .low:      "Low Priority"
        case .standard: "Standard Priority"
        case .high:     "High Priority"
        case .higher:   "Higher Priority"
        case .highest:  "Highest Priority"
        }
    }
    
    var systemImage: String {
        switch self {
        case .none: "minus.circle"
        default:    "\(self.rawValue).square"
        }
    }
}
