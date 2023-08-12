import Foundation

public struct NutrientValue: Codable, Hashable {
    let nutrient: Nutrient
    var value: Double
    var unit: NutrientUnit
    
    init(value: Double, energyUnit: EnergyUnit) {
        self.nutrient = .energy
        self.value = value
        self.unit = energyUnit.nutrientUnit
    }
    
    init(nutrient: Nutrient, value: Double, unit: NutrientUnit) {
        self.nutrient = nutrient
        self.value = value
        self.unit = unit
    }

    init(micro: Micro, value: Double = 0, unit: NutrientUnit = .g) {
        self.nutrient = .micro(micro)
        self.value = value
        self.unit = unit
    }

    init(macro: Macro, value: Double = 0) {
        self.nutrient = .macro(macro)
        self.value = value
        self.unit = .g
    }
    
    init?(_ foodNutrient: FoodNutrient) {
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