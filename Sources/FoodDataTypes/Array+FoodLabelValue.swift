import Foundation

public extension Array where Element == FoodLabelValue {
    var containingUnit: [FoodLabelValue] {
        filter { $0.unit != nil }
    }
}
