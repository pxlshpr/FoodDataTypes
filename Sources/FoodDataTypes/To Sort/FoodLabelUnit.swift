import Foundation

/**
 Units that can appear in a food label.
 */
public enum FoodLabelUnit: Int, CaseIterable, Codable {
    case kcal
    case cup
    case mcg
    case mg
    case kj
    case p
    case g
    case oz
    case ml
    case tbsp
    case iu
    
    public var abbreviation: String {
        switch self {
        case .mg:
            return "mg"
        case .kj:
            return "kJ"
        case .mcg:
            return "mcg"
        case .kcal:
            return "kcal"
        case .p:
            return "%"
        case .g:
            return "g"
        case .cup:
            return "cup"
        case .oz:
            return "oz"
        case .ml:
            return "ml"
        case .tbsp:
            return "tbsp"
        case .iu:
            return "IU"
        }
    }

    public init?(string: String) {
        for unit in Self.allCases {
            if unit.possibleUnits.contains(string) {
                self = unit
                return
            }
        }
        return nil
    }
    
    public var isAllowedInHeader: Bool {
        switch self {
        case .kcal, .mcg, .mg, .kj, .p:
            return false
        default:
            return true
        }
    }
    
    public var regex: String? {
        switch self {
        case .g:
            return "^g$"
        case .oz:
            return "^oz$"
        case .mg:
            return "^(mg|mq)$"
        case .kj:
            return "^(kj|kl)$"
        case .mcg:
            return "^(ug|mcg)$"
        case .kcal:
            return "^(k|)(c|k)al(s|ories|)$"
        case .p:
            return "^%$"
        case .cup:
            return "^cup(s|)$"
        case .ml:
            return "^(ml|mi)$"
        case .tbsp:
            return "^(tbsp|tablespoon(s|))$"
        case .iu:
            return "^(iu)$"
        }
    }
    
    public var possibleUnits: [String] {
        switch self {
        case .g:
            return ["g", "c", "q", "a", "gram", "grams", "€"]
        case .oz:
            return ["oz"]
        case .mg:
            return ["mg", "mq", "ma"]
        case .kj:
            return ["kj", "kl", "kJ", "kilojules"]
        case .mcg:
            return ["mcg", "ug", "vg"]
        case .kcal:
            return ["kcal", "kkal", "kical", "cal", "calorie", "calories"]
        case .p:
            return ["%"]
        case .cup:
            return ["cup", "cups"]
        case .ml:
            return ["ml", "mL", "mi"]
        case .tbsp:
            return ["tbsp", "tablespoon", "tablespoons"]
        case .iu:
            return ["iu", "i.u."]
        }
    }
    
    public static var allUnits: [String] {
        var allUnits: [String] = []
        for unit in allCases {
            allUnits.append(contentsOf: unit.possibleUnits)
        }
        return allUnits
    }
    
    public static var allUnitsRegexOptions = allUnits.joined(separator: "|")
}

extension FoodLabelUnit: CustomStringConvertible {
    public var description: String {
        abbreviation
    }
}

public extension FoodLabelUnit {
    var isNutrientUnit: Bool {
        switch self {
        case .mcg, .mg, .g:
            return true
        default:
            return false
        }
    }
    
    var isEnergy: Bool {
        self == .kcal || self == .kj
    }
}
