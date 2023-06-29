import Foundation

/**
 A value that can appear in a Food Label.
 
 This comprises of an amount and an optional `FoodLabelUnit`.
 */
public struct FoodLabelValue: Codable {
    public var amount: Double
    public var unit: FoodLabelUnit?
    
    public init(amount: Double, unit: FoodLabelUnit? = nil) {
        self.amount = amount
        self.unit = unit
    }
}

extension FoodLabelValue: Equatable {
    public static func ==(lhs: FoodLabelValue, rhs: FoodLabelValue) -> Bool {
        lhs.amount == rhs.amount &&
        lhs.unit == rhs.unit
    }
}
