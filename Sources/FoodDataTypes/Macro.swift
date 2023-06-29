import Foundation

public enum Macro: String, CaseIterable, Codable {
    case carb = "Carbohydrate"
    case fat = "Fat"
    case protein = "Protein"
}

public extension Macro {
    var name: String {
        self.rawValue
    }
}

public extension Macro {
    var attribute: Attribute {
        switch self {
        case .carb:
            return .carbohydrate
        case .fat:
            return .fat
        case .protein:
            return .protein
        }
    }
}
