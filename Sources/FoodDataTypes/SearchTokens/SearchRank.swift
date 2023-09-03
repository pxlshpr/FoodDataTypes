import Foundation

public enum SearchRank: Int, Codable, CaseIterable {
    case none       = -1
    case highest    = 4
    case higher     = 3
    case high       = 2
    case standard   = 1
    case low        = 0
}

public extension SearchRank {
    var description: String {
        switch self {
        case .none:     "Not Included"
        case .low:      "Low Priority"
        case .standard: "Medium Priority"
        case .high:     "High Priority"
        case .higher:   "Higher Priority"
        case .highest:  "Highest Priority"
        }
    }
}
