import Foundation

public enum EnergyUnit: Int, CaseIterable, Codable {
    case kcal = 1
    case kJ
}

public extension EnergyUnit {
    var name: String {
        switch self {
        case .kcal:
            return "Kilocalorie"
        case .kJ:
            return "Kilojule"
        }
    }
    
    var abbreviation: String {
        switch self {
        case .kcal:
            return "kcal"
        case .kJ:
            return "kJ"
        }
    }
}

public extension EnergyUnit {
    var nutrientUnit: NutrientUnit {
        switch self {
        case .kcal: .kcal
        case .kJ:   .kJ
        }
    }
}
