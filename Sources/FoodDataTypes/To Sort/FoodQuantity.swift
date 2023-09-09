import Foundation

public struct FoodQuantity: Hashable {
    public let value: Double
    public let unit: Unit
    public let food: Food
    
    public init(value: Double, unit: Unit, food: Food) {
        self.value = value
        self.unit = unit
        self.food = food
    }
}

//MARK: - Convenience

public extension FoodQuantity {
    init(_ value: Double, _ food: Food) {
        self.init(
            value: value,
            unit: .serving,
            food: food
        )
    }

    init(_ value: Double, _ weightUnit: WeightUnit, _ food: Food) {
        self.init(
            value: value,
            unit: .weight(weightUnit),
            food: food
        )
    }
    
    init(_ value: Double, _ volumeExplicitUnit: VolumeUnit, _ food: Food) {
        self.init(
            value: value,
            unit: .volume(volumeExplicitUnit),
            food: food
        )
    }
    
    init?(_ value: Double, _ sizeId: String, _ food: Food) {
        guard let size = food.quantitySize(for: sizeId) else { return nil}
        self.init(
            value: value,
            unit: .size(size, nil),
            food: food
        )
    }
    
    init?(_ value: Double, _ volumePrefixUnit: VolumeUnit, _ sizeId: String, _ food: Food) {
        guard let size = food.quantitySize(for: sizeId) else { return nil}
        self.init(
            value: value,
            unit: .size(size, volumePrefixUnit),
            food: food
        )
    }
}

extension FoodQuantity: CustomStringConvertible {
    public var description: String {
        "\(value.cleanAmount) \(unit.shortDescription)"
    }
}

public extension FoodQuantity.Size {
    var id: String {
        if let volumeUnit {
            return "\(name)\(volumeUnit.type.rawValue)"
        } else {
            return name
        }
    }
}
