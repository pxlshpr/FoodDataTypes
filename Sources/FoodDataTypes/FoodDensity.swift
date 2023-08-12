import Foundation

public struct FoodDensity: Codable, Hashable {
    public var weightAmount: Double
    public var weightUnit: WeightUnit
    public var volumeAmount: Double
    public var volumeUnit: VolumeUnit
    
    public init(
        weightAmount: Double = 0,
        weightUnit: WeightUnit = .g,
        volumeAmount: Double = 0,
        volumeUnit: VolumeUnit = .cupMetric
    ) {
        self.weightAmount = weightAmount
        self.weightUnit = weightUnit
        self.volumeAmount = volumeAmount
        self.volumeUnit = volumeUnit
    }
}

public extension FoodDensity {
    func convert(weight: WeightQuantity) -> VolumeQuantity {
        /// Protect against divison by 0
        guard self.weightAmount > 0 else { return VolumeQuantity(value: 0, unit: volumeUnit) }
        
        /// first convert the weight to the unit we have in the density
        let convertedWeight = weight.convert(to: self.weightUnit)
        
        let volumeAmount = (convertedWeight * self.volumeAmount) / self.weightAmount
        return VolumeQuantity(value: volumeAmount, unit: self.volumeUnit)
    }
    
    func convert(volume: VolumeQuantity) -> WeightQuantity {
        /// Protect against divison by 0
        guard self.volumeAmount > 0 else { return WeightQuantity(value: 0, unit: weightUnit) }
        
        /// first convert the volume to the unit we have in the density
        let convertedVolume = volume.convert(to: self.volumeUnit)
        
        let weightAmount = (convertedVolume * self.weightAmount) / self.volumeAmount
        return WeightQuantity(value: weightAmount, unit: weightUnit)
    }
}
