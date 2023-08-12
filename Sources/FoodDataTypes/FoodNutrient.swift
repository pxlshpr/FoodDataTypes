import Foundation

struct FoodNutrient: Codable, Hashable {
    
    static let ArraySeparator = "¦"
    static let Separator = "_"
    
    /**
     This can only be `nil` for USDA imported nutrients that aren't yet supported (and must therefore have a `usdaType` if so).
     */
    var micro: Micro?
    
    /**
     This is used to store the id of a USDA nutrient.
     */
    var usdaType: Int?
    var value: Double
    var unit: NutrientUnit
}

extension FoodNutrient {
    
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
