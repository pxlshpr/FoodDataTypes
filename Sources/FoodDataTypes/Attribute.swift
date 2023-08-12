import Foundation

public enum Attribute: String, CaseIterable, Codable {
    
    case tableElementNutritionFacts
    case tableElementSkippable
    
    case nutrientLabelTotal
    
    //MARK: - Serving
    case servingAmount                 /// Double
    case servingUnit                  /// NutritionUnit
    case servingUnitSize              /// String
    case servingEquivalentAmount       /// Double
    case servingEquivalentUnit        /// NutritionUnit
    case servingEquivalentUnitSize    /// String
    
    case servingsPerContainerAmount
    case servingsPerContainerName
    
    //MARK: - Header
    /// Header type for column 1 and 2, which indicates if they are a `per100g` or `perServing` column
    case headerType1
    case headerType2
    
    /// Header serving attributes which gets assigned to whichever column has the `perServing` type
    case headerServingAmount
    case headerServingUnit
    case headerServingUnitSize
    case headerServingEquivalentAmount
    case headerServingEquivalentUnit
    case headerServingEquivalentUnitSize
    
    //MARK: - Nutrient
    case energy
    
    //MARK: Core Table Nutrients
    case protein
    
    case carbohydrate
    case gluten
    case sugar
    case addedSugar
    case polyols
    case starch
    
    case dietaryFibre
    case solubleFibre
    case insolubleFibre
    
    case fat
    case saturatedFat
    case polyunsaturatedFat
    case monounsaturatedFat
    case transFat
    case cholesterol
    
    case salt
    case sodium
    
    //MARK: Additional Table Nutrients (Usually at bottom)
    case calcium
    case iron
    case potassium
    case cobalamin
    case magnesium
    case zinc
    case iodine
    case selenium
    case manganese
    case chromium
    case phosphorus
    
    case thiamin
    case folate
    case folicAcid
    case biotin
    case pantothenicAcid
    case riboflavin
    case niacin
    case vitaminA
    case vitaminC
    case vitaminD
    case vitaminB1
    case vitaminB3
    case vitaminB6
    case vitaminB2
    case vitaminB12
    case vitaminE
    case vitaminK
    case vitaminK2
    
    case taurine
    case caffeine
}

public extension Attribute {
    var defaultUnit: FoodLabelUnit? {
        supportedUnits.first
    }
    
    func supportsUnit(_ unit: FoodLabelUnit) -> Bool {
        supportedUnits.contains(unit)
    }
    
    var supportedUnits: [FoodLabelUnit] {
        switch self {
            
        case .energy:
            return [ .kcal, .kj ]
            
        case .protein, .carbohydrate, .fat, .salt:
            return [.g]
            
        case .dietaryFibre, .solubleFibre, .insolubleFibre, .saturatedFat, .polyunsaturatedFat, .monounsaturatedFat, .transFat, .sugar, .addedSugar, .gluten, .starch, .polyols:
            return [.g, .mg, .mcg]
            
        case .cholesterol, .sodium, .calcium, .iron, .potassium, .cobalamin, .vitaminA, .vitaminC, .vitaminD, .vitaminB6, .zinc, .iodine, .selenium, .magnesium, .manganese, .chromium, .thiamin, .folate, .biotin, .pantothenicAcid, .riboflavin, .niacin, .vitaminB1, .vitaminB3, .vitaminE, .vitaminK, .vitaminK2, .taurine, .caffeine, .vitaminB2, .phosphorus:
            return [.mg, .mcg, .p, .g]
            
        case .folicAcid, .vitaminB12:
            return [.mcg, .mg, .p, .g]
            
        case .servingAmount:
            return [.cup, .g, .mcg, .mg]
            
        case .tableElementNutritionFacts, .tableElementSkippable, .nutrientLabelTotal, .servingUnit, .servingUnitSize, .servingEquivalentAmount, .servingEquivalentUnit, .servingEquivalentUnitSize, .servingsPerContainerAmount, .servingsPerContainerName, .headerType1, .headerType2, .headerServingAmount, .headerServingUnit, .headerServingUnitSize, .headerServingEquivalentAmount, .headerServingEquivalentUnit, .headerServingEquivalentUnitSize:
            return []
        }
    }
    
}

public extension Attribute {
    var macro: Macro? {
        switch self {
        case .carbohydrate:
            return .carb
        case .fat:
            return .fat
        case .protein:
            return .protein
        default:
            return nil
        }
    }
}

public extension Attribute {
    var nutrient: Nutrient? {
        if self == .energy {
            return .energy
        }
        if let macro {
            return .macro(macro)
        }
        if let micro {
            return .micro(micro)
        }
        return nil
    }
}

public extension Attribute {
    var micro: Micro? {
        Micro.allCases.first(where: { $0.attribute == self })
    }
}

public extension Micro {
    var attribute: Attribute? {
        switch self {
        case .saturatedFat:
            return .saturatedFat
        case .monounsaturatedFat:
            return .monounsaturatedFat
        case .polyunsaturatedFat:
            return .polyunsaturatedFat
        case .transFat:
            return .transFat
        case .cholesterol:
            return .cholesterol
        case .dietaryFiber:
            return .dietaryFibre
        case .solubleFiber:
            return .solubleFibre
        case .insolubleFiber:
            return .insolubleFibre
        case .sugars:
            return .sugar
        case .addedSugars:
            return .addedSugar
        case .calcium:
            return .calcium
        case .chromium:
            return .chromium
        case .iodine:
            return .iodine
        case .iron:
            return .iron
        case .magnesium:
            return .magnesium
        case .manganese:
            return .manganese
        case .potassium:
            return .potassium
        case .selenium:
            return .selenium
        case .sodium:
            return .sodium
        case .zinc:
            return .zinc
        case .vitaminA:
            return .vitaminA
        case .vitaminB6_pyridoxine:
            return .vitaminB6
        case .vitaminB12_cobalamin:
            return .vitaminB12
        case .vitaminC_ascorbicAcid:
            return .vitaminC
        case .vitaminD_calciferol:
            return .vitaminD
        case .vitaminE:
            return .vitaminE
        case .vitaminK1_phylloquinone:
            return .vitaminK
        case .vitaminB7_biotin:
            return .biotin
        case .vitaminB9_folate:
            return .folate
        case .vitaminB3_niacin:
            return .niacin
        case .vitaminB5_pantothenicAcid:
            return .pantothenicAcid
        case .vitaminB2_riboflavin:
            return .riboflavin
        case .vitaminB1_thiamine:
            return .thiamin
        case .vitaminB9_folicAcid:
            return .folicAcid
        case .vitaminK2_menaquinone:
            return .vitaminK2
        case .caffeine:
            return .caffeine
        case .taurine:
            return .taurine
        case .polyols:
            return .polyols
        case .gluten:
            return .gluten
        case .starch:
            return .starch
        case .salt:
            return .salt
            
        case .phosphorus:
            return .phosphorus
            
        /// No support (yet) for remaining ones, add entry into `Attribute` First
            
        default:
            return nil
        }
    }
}
