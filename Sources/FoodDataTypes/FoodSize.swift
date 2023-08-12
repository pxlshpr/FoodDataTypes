import Foundation

public struct FoodSize: Identifiable, Codable, Hashable {
    
    public var quantity: Double
    public var name: String
    public var volumeUnit: VolumeUnit?
    public var value: FoodValue
    
    public var id: String {
        if let volumeUnit {
            return "\(name)\(volumeUnit.type.rawValue)"
        } else {
            return name
        }
    }
    
    /// Separators used for the string representation
    public static let Separator = "¬"
    public static let ArraySeparator = "¦"
    
    public init(
        quantity: Double,
        name: String,
        volumeUnit: VolumeUnit?,
        value: FoodValue
    ) {
        self.quantity = quantity
        self.name = name
        self.volumeUnit = volumeUnit
        self.value = value
    }
}

public extension FoodSize {
    
    init(_ formSize: FormSize) {
        self.init(
            quantity: formSize.quantity ?? 1,
            name: formSize.name,
            volumeUnit: formSize.volumeUnit,
            value: formSize.foodValue
        )
    }
    
    func formSize(for food: Food) -> FormSize? {
        guard let unit = self.value.formUnit(for: food) else {
            return nil
        }
        return FormSize(
            quantity: self.quantity,
            volumeUnit: self.volumeUnit,
            name: self.name,
            amount: self.value.value,
            unit: unit
        )
    }
}

//public extension FoodSize {
//    var asString: String {
//        "\(name)"
//        + "\(Self.Separator)\(quantity)"
//        + "\(Self.Separator)\(volumeUnit?.rawValue ?? NilInt)"
//        + "\(Self.Separator)\(value.asString)"
//    }
//    
//    init(string: String) {
//        let components = string.components(separatedBy: Self.Separator)
//        guard components.count == 4 else { fatalError() }
//        let name = components[0]
//        let quantityString = components[1]
//        let volumeUnitString = components[2]
//        let valueString = components[3]
//        
//        guard let quantity = Double(quantityString) else { fatalError() }
//
//        guard let volumeUnitInt = Int(volumeUnitString) else { fatalError() }
//        let volumeUnit: VolumeUnit?
//        if volumeUnitInt == NilInt {
//            volumeUnit = nil
//        } else {
//            volumeUnit = VolumeUnit(rawValue: volumeUnitInt)
//        }
//
//        let value = FoodValue(string: valueString)
//        self.name = name
//        self.quantity = quantity
//        self.volumeUnit = volumeUnit
//        self.value = value
//    }
//}

public extension Array where Element == FoodSize {
    func sizeMatchingUnitSizeInFoodValue(_ foodValue: FoodValue) -> FoodSize? {
        first(where: { $0.id == foodValue.sizeID })
    }
}
