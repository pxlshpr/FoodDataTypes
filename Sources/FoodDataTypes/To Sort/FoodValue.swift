import Foundation

public struct FoodValue: Codable, Hashable {
    
    public var value: Double
    public var unitType: UnitType
    public var weightUnit: WeightUnit?
    public var volumeUnit: VolumeUnit?
    public var sizeID: String?
    public var sizeVolumeUnit: VolumeUnit?
    
    public init(
        value: Double,
        unitType: UnitType,
        weightUnit: WeightUnit? = nil,
        volumeUnit: VolumeUnit? = nil,
        sizeID: String? = nil,
        sizeVolumeUnit: VolumeUnit? = nil
    ) {
        self.value = value
        self.unitType = unitType
        self.weightUnit = weightUnit
        self.volumeUnit = volumeUnit
        self.sizeID = sizeID
        self.sizeVolumeUnit = sizeVolumeUnit
    }
    
    /// Separators used for the string representation
    public static let Separator = "_"
}

public extension FoodValue {
    init(_ value: Double, _ unit: FormUnit) {
        self.init(
            value: value,
            unitType: unit.unitType,
            weightUnit: unit.weightUnit,
            volumeUnit: unit.volumeUnit,
            sizeID: unit.sizeID,
            sizeVolumeUnit: unit.sizeVolumeUnit
        )
    }
}

public extension FoodValue {
    func formUnit(for food: Food) -> FormUnit? {
        switch unitType {
        case .serving:
            return .serving
        case .size:
            guard let sizeID,
                  let foodSize = food.sizes.first(where: { $0.id == sizeID }),
                  let formSize = foodSize.formSize(for: food)
            else { return nil }
            return .size(formSize, sizeVolumeUnit)
        case .volume:
            guard let volumeUnit else { return nil }
            return .volume(volumeUnit)
        case .weight:
            guard let weightUnit else { return nil }
            return .weight(weightUnit)
        }
    }
}

//public extension FoodValue {
//    
//    var asString: String {
//        "\(value)"
//        + "\(Self.Separator)\(unitType.rawValue)"
//        + "\(Self.Separator)\(weightUnit?.rawValue ?? NilInt)"
//        + "\(Self.Separator)\(volumeUnit?.rawValue ?? NilInt)"
//        + "\(Self.Separator)\(sizeID ?? "")"
//        + "\(Self.Separator)\(sizeVolumeUnit?.rawValue ?? NilInt)"
//    }
//    
//    init(string: String) {
//        let components = string.components(separatedBy: Self.Separator)
//        guard components.count == 6 else { fatalError() }
//        let valueString = components[0]
//        let unitTypeString = components[1]
//        let weightUnitString = components[2]
//        let volumeUnitString = components[3]
//        let sizeIdString = components[4]
//        let sizeVolumeUnitString = components[5]
//        
//        guard let value = Double(valueString) else { fatalError() }
//
//        guard let unitTypeInt = Int(unitTypeString) else { fatalError() }
//        guard let unitType = UnitType(rawValue: unitTypeInt) else { fatalError() }
//
//        guard let weightUnitInt = Int(weightUnitString) else { fatalError() }
//        let weightUnit: WeightUnit?
//        if weightUnitInt == NilInt {
//            weightUnit = nil
//        } else {
//            weightUnit = WeightUnit(rawValue: weightUnitInt)
//        }
//
//        guard let volumeUnitInt = Int(volumeUnitString) else { fatalError() }
//        let volumeUnit: VolumeUnit?
//        if volumeUnitInt == NilInt {
//            volumeUnit = nil
//        } else {
//            volumeUnit = VolumeUnit(rawValue: volumeUnitInt)
//        }
//
//        let sizeID: String?
//        if sizeIdString.isEmpty {
//            sizeID = nil
//        } else {
//            sizeID = sizeIdString
//        }
//
//        guard let sizeVolumeUnitInt = Int(sizeVolumeUnitString) else { fatalError() }
//        let sizeVolumeUnit: VolumeUnit?
//        if sizeVolumeUnitInt == NilInt {
//            sizeVolumeUnit = nil
//        } else {
//            sizeVolumeUnit = VolumeUnit(rawValue: sizeVolumeUnitInt)
//        }
//
//        self.value = value
//        self.unitType = unitType
//        self.weightUnit = weightUnit
//        self.volumeUnit = volumeUnit
//        self.sizeID = sizeID
//        self.sizeVolumeUnit = sizeVolumeUnit
//    }
//}

public extension FoodValue {
    func foodSizeUnit(in food: Food) -> FoodSize? {
        food.sizes.first(where: { $0.id == self.sizeID })
    }
    
    func formSizeUnit(in food: Food) -> FormSize? {
        guard let foodSize = foodSizeUnit(in: food) else {
            return nil
        }
        return FormSize(foodSize: foodSize, in: food.sizes)
    }

    func isWeightBased(in food: Food) -> Bool {
        unitType == .weight || hasWeightBasedSizeUnit(in: food)
    }

    func isVolumeBased(in food: Food) -> Bool {
        unitType == .volume || hasVolumeBasedSizeUnit(in: food)
    }
    
    func hasVolumeBasedSizeUnit(in food: Food) -> Bool {
        formSizeUnit(in: food)?.isVolumeBased == true
    }
    
    func hasWeightBasedSizeUnit(in food: Food) -> Bool {
        formSizeUnit(in: food)?.isWeightBased == true
    }
}


public extension FoodValue {
    func description(with food: Food) -> String {
        "\(value.cleanAmount) \(unitDescription(sizes: food.sizes))"
    }
    
//    func description(with ingredientFood: IngredientFood) -> String {
//        "\(value.cleanAmount) \(unitDescription(sizes: ingredientFood.info.sizes))"
//    }
}

public extension FoodValue {
    func unitDescription(sizes: [FoodSize]) -> String {
        switch self.unitType {
        case .serving:
            return "serving"
        case .weight:
            guard let weightUnit else {
                return "invalid weight"
            }
            return weightUnit.abbreviation
        case .volume:
            guard let type = volumeUnit?.type else {
                return "invalid volume"
            }
            return type.abbreviation
        case .size:
            guard let size = sizes.sizeMatchingUnitSizeInFoodValue(self) else {
                return "invalid size"
            }
            if let type = size.volumeUnit?.type {
                return "\(type.abbreviation) \(size.name)"
            } else {
                return size.name
            }
        }
    }
}

public extension FoodValue {
    func matches(_ other: FoodValue) -> Bool {
        value.matches(other.value)
        && unitType == other.unitType
        && weightUnit == other.weightUnit
        && volumeUnit == other.volumeUnit
        && sizeID == other.sizeID
        && sizeVolumeUnit == other.sizeVolumeUnit
    }
}
