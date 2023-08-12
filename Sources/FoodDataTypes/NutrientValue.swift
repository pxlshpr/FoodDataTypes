import Foundation

public struct NutrientValue: Codable, Hashable {
    public let nutrient: Nutrient
    public var value: Double
    public var unit: NutrientUnit
    
    public init(value: Double, energyUnit: EnergyUnit) {
        self.nutrient = .energy
        self.value = value
        self.unit = energyUnit.nutrientUnit
    }
    
    public init(nutrient: Nutrient, value: Double, unit: NutrientUnit) {
        self.nutrient = nutrient
        self.value = value
        self.unit = unit
    }

    public init(micro: Micro, value: Double = 0, unit: NutrientUnit = .g) {
        self.nutrient = .micro(micro)
        self.value = value
        self.unit = unit
    }

    public init(macro: Macro, value: Double = 0) {
        self.nutrient = .macro(macro)
        self.value = value
        self.unit = .g
    }
    
    public init?(_ foodNutrient: FoodNutrient) {
        guard let micro = foodNutrient.micro else {
            return nil
        }
        self.nutrient = .micro(micro)
        self.value = foodNutrient.value
        self.unit = foodNutrient.unit
    }
}

public extension NutrientValue {
    var micro: Micro? {
        switch nutrient {
        case .micro(let micro): micro
        default:                nil
        }
    }
    
    var macro: Macro? {
        switch nutrient {
        case .macro(let macro): macro
        default:                nil
        }
    }
    
    var isEnergy: Bool {
        switch nutrient {
        case .energy:   true
        default:        false
        }
    }

    var isMacro: Bool {
        switch nutrient {
        case .macro:   true
        default:       false
        }
    }
}

public extension NutrientValue {
    init?(extractedNutrient: ExtractedNutrient) {
        guard let nutrient = extractedNutrient.attribute.nutrient,
              let amount = extractedNutrient.value?.amount,
              let unit = extractedNutrient.value?.unit?.nutrientUnit
        else {
            return nil
        }
        self.nutrient = nutrient
        self.value = amount
        self.unit = unit
    }
}

public extension FoodLabelUnit {
    var nutrientUnit: NutrientUnit? {
        switch self {
        case .kcal: .kcal
        case .mcg:  .mcg
        case .mg:   .mg
        case .kj:   .kJ
        case .p:    .p
        case .g:    .g
        case .iu:   .IU
        default:    nil
        }
    }
}

public extension NutrientValue {
    func matches(_ other: NutrientValue) -> Bool {
        nutrient == other.nutrient
        && unit == other.unit
        && value.matches(other.value)
    }
}

public extension Array where Element == NutrientValue {
    func matches(_ other: [NutrientValue]) -> Bool {
        for nutrientValue in self {
            guard other.contains(where: { $0.matches(nutrientValue)}) else {
                return false
            }
        }
        return true
    }
}

public extension Double {
    func matches(_ other: Double) -> Bool {
        self.rounded(toPlaces: 1) == other.rounded(toPlaces: 1)
    }
}
