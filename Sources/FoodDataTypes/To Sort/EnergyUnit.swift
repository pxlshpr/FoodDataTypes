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

public extension EnergyUnit {
    func convert(_ value: Double, to unit: EnergyUnit) -> Double {
        switch self {
        case .kcal:
            switch unit {
            case .kcal:
                return value
            case .kJ:
                return value * KjPerKcal
            }
        case .kJ:
            switch unit {
            case .kcal:
                return value / KjPerKcal
            case .kJ:
                return value
            }
        }
    }
}

public extension EnergyUnit {
    var foodLabelUnit: FoodLabelUnit {
        switch self {
        case .kcal: .kcal
        case .kJ:   .kj
        }
    }
}
