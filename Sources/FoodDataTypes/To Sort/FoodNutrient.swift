import Foundation

public struct FoodNutrient: Codable, Hashable {
    
    static let ArraySeparator = "¦"
    static let Separator = "_"
    
    /**
     This can only be `nil` for USDA imported nutrients that aren't yet supported (and must therefore have a `usdaType` if so).
     */
    public var micro: Micro?
    
    /**
     This is used to store the id of a USDA nutrient.
     */
    public var usdaType: Int?
    public var value: Double
    public var unit: NutrientUnit
    
    public init(micro: Micro? = nil, usdaType: Int? = nil, value: Double, unit: NutrientUnit) {
        self.micro = micro
        self.usdaType = usdaType
        self.value = value
        self.unit = unit
    }
}

public extension FoodNutrient {
    
    init?(_ nutrientValue: NutrientValue) {
        guard let micro = nutrientValue.micro else { return nil }
        self.init(
            micro: micro,
            usdaType: nil,
            value: nutrientValue.value,
            unit: nutrientValue.unit
        )
    }
}

extension FoodNutrient {
    var valueInGrams: Double {
        switch unit {
        case .g:
            return value
        case .mg, .mgAT, .mgNE, .mgGAE:
            return value / 1000.0
        case .mcg, .mcgDFE, .mcgRAE:
            return value / 1000000.0
        default:
            return 0
        }
    }
}
