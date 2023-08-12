import Foundation

public struct VolumeQuantity: Hashable {
    public let value: Double
    public let unit: VolumeUnit
    
    public init(value: Double, unit: VolumeUnit) {
        self.value = value
        self.unit = unit
    }
}

public extension VolumeQuantity {
    init(_ value: Double, _ unit: VolumeUnit) {
        self.init(value: value, unit: unit)
    }
}

extension VolumeQuantity: Equatable {
    /// Note: Equality is determined by comparing values to **two decimal places**
    public static func ==(lhs: VolumeQuantity, rhs: VolumeQuantity) -> Bool {
        lhs.unit == rhs.unit
        && lhs.value.rounded(toPlaces: 2) == rhs.value.rounded(toPlaces: 2)
    }
}

public extension VolumeQuantity {
    var valueInML: Double {
        value * unit.mL
    }
    
    func convert(to volumeUnit: VolumeUnit) -> Double {
        valueInML / volumeUnit.mL
    }
}
