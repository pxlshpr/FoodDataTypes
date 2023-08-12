import Foundation

public struct WeightQuantity: Hashable {
    public let value: Double
    public let unit: WeightUnit
    
    public init(value: Double, unit: WeightUnit) {
        self.value = value
        self.unit = unit
    }
}

public extension WeightQuantity {
    init(_ value: Double, _ unit: WeightUnit) {
        self.init(value: value, unit: unit)
    }
}

/// Note: Equality is determined by comparing values to **two decimal places**
extension WeightQuantity: Equatable {
    public static func ==(lhs: WeightQuantity, rhs: WeightQuantity) -> Bool {
        lhs.unit == rhs.unit
        && lhs.value.rounded(toPlaces: 2) == rhs.value.rounded(toPlaces: 2)
    }
}

public extension WeightQuantity {
    var valueInGrams: Double {
        value * unit.g
    }
    
    func convert(to weightUnit: WeightUnit) -> Double {
        valueInGrams / weightUnit.g
    }
}

