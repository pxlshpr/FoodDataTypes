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
