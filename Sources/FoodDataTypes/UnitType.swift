import Foundation

public enum UnitType: Int, Codable, CaseIterable, Hashable {
    case weight = 1
    case volume
    case serving
    case size
}

public extension UnitType {
    var description: String {
        switch self {
        case .weight:
            return "Weight"
        case .volume:
            return "Volume"
        case .serving:
            return "Serving"
        case .size:
            return "Size"
        }
    }
}
