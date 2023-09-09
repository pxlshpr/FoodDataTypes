import Foundation
//import FoodLabel

//private let logger = Logger(subsystem: "FoodItem", category: "")

public struct FoodItem: Identifiable, Codable, Hashable {
    public var id: UUID
    
    public var amount: FoodValue
    public var food: Food
    public var mealID: UUID?
    public var recipeFoodID: UUID?

    public var energy: Double
    public var energyUnit: EnergyUnit
    public var carb: Double
    public var fat: Double
    public var protein: Double
    public var micros: [FoodNutrient]

    public var largestEnergyInKcal: Double
    
    public var sortPosition: Int
    
    public var eatenAt: Date?
    public var updatedAt: Date
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        amount: FoodValue,
        food: Food,
        mealID: UUID? = nil,
        recipeFoodID: UUID? = nil,
        energy: Double,
        energyUnit: EnergyUnit,
        carb: Double,
        fat: Double,
        protein: Double,
        micros: [FoodNutrient],
        largestEnergyInKcal: Double,
        sortPosition: Int = 0,
        eatenAt: Date? = nil,
        updatedAt: Date = Date.now,
        createdAt: Date = Date.now
    ) {
        self.id = id
        self.amount = amount
        self.food = food
        self.mealID = mealID
        self.recipeFoodID = recipeFoodID
        self.energy = energy
        self.energyUnit = energyUnit
        self.carb = carb
        self.fat = fat
        self.protein = protein
        self.micros = micros
        self.largestEnergyInKcal = largestEnergyInKcal
        self.sortPosition = sortPosition
        self.eatenAt = eatenAt
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }

    public init(
        food: Food,
        amount: FoodValue
    ) {
        
        let energy = food.value(for: .energy, with: amount)
        let carb = food.value(for: .macro(.carb), with: amount)
        let fat = food.value(for: .macro(.fat), with: amount)
        let protein = food.value(for: .macro(.protein), with: amount)

        let micros: [FoodNutrient] = food.micros(for: amount)
        
        self.init(
            amount: amount,
            food: food,
            energy: energy,
            energyUnit: food.energyUnit,
            carb: carb,
            fat: fat,
            protein: protein,
            micros: micros,
            largestEnergyInKcal: energy
        )
    }
    
}

public extension FoodItem {
    var energyFoodLabelValue: FoodLabelValue {
        FoodLabelValue(amount: energy, unit: energyUnit.foodLabelUnit)
    }
    
//    var foodLabelData: FoodLabelData {
//        FoodLabelData(
//            energyValue: energyFoodLabelValue,
//            carb: carb,
//            fat: fat,
//            protein: protein,
//            nutrients: microsDictForPreview,
//            quantityValue: amount.value,
//            quantityUnit: amount.unitDescription(sizes: food.sizes)
//        )
//    }
    
    /// Used for `FoodLabel`
    var microsDict: [Micro : FoodLabelValue] {
        var dict: [Micro : FoodLabelValue] = [:]
        for nutrientValue in food.micros {
            guard let micro = nutrientValue.micro else { continue }
            dict[micro] = FoodLabelValue(
                amount: calculateMicro(micro),
                unit:
                    nutrientValue.unit.foodLabelUnit
                    ?? micro.defaultUnit.foodLabelUnit
                    ?? .g
            )
        }
        return dict
    }
    
    var microsDictForPreview: [Micro : FoodLabelValue] {
        microsDict
            .filter { $0.key.isIncludedInPreview }
    }

}

public extension FoodItem {
    func calculateEnergy(in unit: EnergyUnit) -> Double {
        food.calculateEnergy(in: unit, for: amount)
    }

    func calculateMacro(_ macro: Macro) -> Double {
        food.calculateMacro(macro, for: amount)
    }
    
    func calculateMicro(_ micro: Micro, in unit: NutrientUnit? = nil) -> Double {
        food.calculateMicro(micro, for: amount, in: unit)
    }
}

public extension FoodItem {
    var quantityDescription: String {
        amount.description(with: food)
    }
}

extension FoodItem: Comparable {
    public static func <(lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs.sortPosition < rhs.sortPosition
    }
}

public extension Array where Element == FoodItem {
    func matches(_ other: [FoodItem]) -> Bool {
        guard self.count == other.count else { return false }
        for i in indices {
            guard self[i].matches(other[i]) else {
                return false
            }
        }
        return true
    }
}

public extension FoodItem {
    func matches(_ other: FoodItem) -> Bool {
        id == other.id
        && amount.matches(other.amount)
        && food == other.food
        && mealID == other.mealID
        && energyUnit == other.energyUnit
        && sortPosition == other.sortPosition
        
        && energy.matches(other.energy)
        && carb.matches(other.carb)
        && fat.matches(other.fat)
        && protein.matches(other.protein)
        && largestEnergyInKcal.matches(other.largestEnergyInKcal)
        
        && eatenAt == other.eatenAt
//        && updatedAt == other.updatedAt
//        && createdAt == other.createdAt
    }
}

public extension FoodItem {
//    func value(for component: NutrientMeterComponent) -> Double {
//        switch component {
//        case .energy(let unit):             energyUnit.convert(energy, to: unit)
//        case .macro(let macro):             value(for: macro)
//        case .micro(let micro, let unit):   value(for: micro, in: unit)
//        }
//    }
    
    var energyInKcal: Double {
        energyUnit.convert(energy, to: .kcal)
    }
}

public extension FoodItem {
    func value(for macro: Macro) -> Double {
        switch macro {
        case .carb: carb
        case .protein: protein
        case .fat: fat
        }
    }

    func valueForEnergy(in unit: EnergyUnit) -> Double {
        energyUnit.convert(energy, to: unit)
    }

    func value(for micro: Micro, in unit: NutrientUnit) -> Double {
        food.value(for: .micro(micro), with: amount)
    }
}

public extension Array where Element == FoodItem {
    var largestEnergyInKcal: Double {
        self
            .map { $0.energyUnit.convert($0.energy, to: .kcal) }
            .sorted()
            .last ?? 0
    }
    
    mutating func setLargestEnergy() {
        let largest = largestEnergyInKcal
        for i in indices {
            self[i].largestEnergyInKcal = largest
        }
    }
}

public extension FoodItem {
    var calculatedMicros: [FoodNutrient] {
        food.micros(for: self.amount)
    }
}

//extension FoodItem {
//    func scaledValue(for component: NutrientMeterComponent) -> Double {
//        0
////        guard let value = food.info.nutrients.value(for: component) else { return 0 }
////        return value * nutrientScaleFactor
//    }
//}
