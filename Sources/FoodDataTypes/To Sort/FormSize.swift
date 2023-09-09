import Foundation

public struct FormSize: Hashable, Codable {

    public var quantity: Double?
    public var name: String
    public var volumeUnit: VolumeUnit?
    public var unit: FormUnit
    public var amount: Double?
    
    public init(
        quantity: Double? = 1,
        volumeUnit: VolumeUnit? = nil,
        name: String = "",
        amount: Double? = 100,
        unit: FormUnit = .weight(.g)
    ) {
        self.quantity = quantity
        self.name = name
        self.volumeUnit = volumeUnit
        self.unit = unit
        self.amount = amount
    }
}

public extension FormSize {
    var quantityString: String {
        guard let quantity, quantity != 1 else { return "" }
        return "\(quantity.cleanAmount) × "
    }

    var amountString: String {
        guard let amount else { return "" }
        return "\(amount.cleanAmount) \(unit.abbreviation)"
    }
    
    var foodValue: FoodValue {
        FoodValue(amount ?? 0, unit)
    }
}

extension FormSize: Identifiable {
    /**
     An identifier that is generated with the name (and the volume unit suffixed if present)
     to ensure uniqueness amongst sizes in a food.
     */
    public var id: String {
        if let volumeUnit {
            return "\(name)\(volumeUnit.type.rawValue)"
        } else {
            return name
        }
    }
}

extension FormSize: Comparable {

    public static func <(lhs: FormSize, rhs: FormSize) -> Bool {
        return lhs.id < rhs.id
    }
}

public extension FormSize {
    /**
     The name of the size, prefixed with the volume unit, if provided.
     */
    func fullName(volumeUnit: VolumeUnit?) -> String {
        if let volumeUnit = volumeUnit {
            return "\(name) (\(volumeUnit.abbreviation))"
        } else {
            return name
        }
    }
    
    /**
     The name of the size, prefixed with the volume unit, if present.
     */
    var fullName: String {
        fullName(volumeUnit: volumeUnit)
    }
    
    var isVolumePrefixed: Bool {
        volumeUnit != nil
    }
    
    var isWeightBased: Bool {
        unit.isWeightBased
    }
    
    var isVolumeBased: Bool {
        unit.isVolumeBased
    }
    var isSizeBased: Bool {
        unit.isSizeBased
    }
    
    var isServingBased: Bool {
        unit.isServingBased
    }
    
    /// Unit to replace this size when deleting it (if used for amount or serving)
    var replacementUnit: FormUnit {
        unit.replacementUnit
    }
}

public extension FormSize {
    init(foodQuantitySize size: FoodQuantity.Size) {
        self.init(
            quantity: size.quantity,
            volumeUnit: size.volumeUnit,
            name: size.name,
            amount: size.value,
            unit: FormUnit(foodQuantityUnit: size.unit)
        )
    }
}

public extension FormSize {
    func matches(_ other: FormSize) -> Bool {
        if let quantity {
            guard let otherQuantity = other.quantity,
                  otherQuantity.matches(quantity) else {
                return false
            }
        } else {
            guard other.quantity == nil else {
                return false
            }
        }
        
        if let amount {
            guard let otherAmount = other.amount,
                  otherAmount == amount else {
                return false
            }
        } else {
            guard other.amount == nil else {
                return false
            }
        }
        
        return name == other.name
        && volumeUnit == other.volumeUnit
        && unit == other.unit
    }
}

public extension Array where Element == FormSize {
    func matches(_ other: [FormSize]) -> Bool {
        for size in self {
            guard other.contains(where: { $0.matches(size) }) else {
                return false
            }
        }
        return true
    }
}
