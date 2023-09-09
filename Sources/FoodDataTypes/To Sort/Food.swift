import Foundation

public struct Food: Identifiable, Codable, Hashable {
    public var id: UUID
    
    public var emoji: String
    public var name: String
    public var detail: String?
    public var brand: String?
    
    public var amount: FoodValue
    public var serving: FoodValue?
    public var previewAmount: FoodValue?
    
    public var energy: Double
    public var energyUnit: EnergyUnit
    
    public var carb: Double
    public var protein: Double
    public var fat: Double
    
    public var micros: [FoodNutrient]
    
    public var sizes: [FoodSize]
    public var density: FoodDensity?
    
    public var url: String?
    public var imageIDs: [UUID]
    public var barcodes: [String]
    
    public var type: FoodType
    public var publishStatus: PublishStatus?
    public var dataset: FoodDataset?
    public var datasetID: String?
    
    public var lastAmount: FoodValue?

    public var updatedAt: Date
    public var createdAt: Date
    public var isTrashed: Bool

    public var childrenFoodItems: [FoodItem]
    
    public var ownerID: String?
    
    public var reviewerID: String?
    public var rejectionReasons: [RejectionReason]?
    public var rejectionNotes: String?
    public var searchTokens: [FlattenedSearchToken]
    
    public var isPendingNotification: Bool
    
    public init(
        id: UUID = UUID(),
        emoji: String = String.randomFoodEmoji,
        name: String = "",
        detail: String? = nil,
        brand: String? = nil,
        amount: FoodValue = FoodValue(100, .weight(.g)),
        serving: FoodValue? = FoodValue(100, .weight(.g)),
        previewAmount: FoodValue? = FoodValue(100, .weight(.g)),
        energy: Double = 0,
        energyUnit: EnergyUnit = .kcal,
        carb: Double = 0,
        protein: Double = 0,
        fat: Double = 0,
        micros: [FoodNutrient] = [],
        sizes: [FoodSize] = [],
        density: FoodDensity? = nil,
        url: String? = nil,
        imageIDs: [UUID] = [],
        barcodes: [String] = [],
        type: FoodType = .food,
        publishStatus: PublishStatus? = nil,
        dataset: FoodDataset? = nil,
        datasetID: String? = nil,
        lastAmount: FoodValue? = nil,
        updatedAt: Date = Date.now,
        createdAt: Date = Date.now,
        isTrashed: Bool = false,
        childrenFoodItems: [FoodItem] = [],
        ownerID: String? = nil,
        rejectionReasons: [RejectionReason]? = nil,
        rejectionNotes: String? = nil,
        reviewerID: String? = nil,
        searchTokens: [FlattenedSearchToken] = [],
        isPendingNotification: Bool = false
    ) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.detail = detail
        self.brand = brand
        self.amount = amount
        self.serving = serving
        self.previewAmount = previewAmount
        self.energy = energy
        self.energyUnit = energyUnit
        self.carb = carb
        self.protein = protein
        self.fat = fat
        self.micros = micros
        self.sizes = sizes
        self.density = density
        self.url = url
        self.imageIDs = imageIDs
        self.barcodes = barcodes
        self.type = type
        self.publishStatus = publishStatus
        self.dataset = dataset
        self.datasetID = datasetID
        self.lastAmount = lastAmount
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.isTrashed = isTrashed
        self.childrenFoodItems = childrenFoodItems
        self.ownerID = ownerID
        self.rejectionReasons = rejectionReasons
        self.rejectionNotes = rejectionNotes
        self.reviewerID = reviewerID
        self.searchTokens = searchTokens
        self.isPendingNotification = isPendingNotification
    }
}

public extension Food {

    func quantity(for amount: FoodValue) -> FoodQuantity? {
        guard let unit = FoodQuantity.Unit(foodValue: amount, in: self) else { return nil }
        return FoodQuantity(value: amount.value, unit: unit, food: self)
    }
    
    var foodQuantitySizes: [FoodQuantity.Size] {
        sizes.compactMap { foodSize in
            FoodQuantity.Size(foodSize: foodSize, in: self)
        }
    }

    func possibleUnits(
        without unit: FoodQuantity.Unit,
        using volumeUnits: VolumeUnits) -> [FoodQuantity.Unit]
    {
        possibleUnits(using: volumeUnits).filter {
            /// If the units are both sizes—compare the sizes alone to exclude any potential different volume prefixes
            if let possibleSize = $0.size, let size = unit.size {
                return possibleSize.id != size.id
            } else {
                return $0 != unit
            }
        }
    }
    
    func possibleUnits(using volumeUnits: VolumeUnits) -> [FoodQuantity.Unit] {
        var units: [FoodQuantity.Unit] = []
        for size in foodQuantitySizes {
            var volumePrefix: VolumeUnit? = nil
            if let volumeUnit = size.volumeUnit {
                volumePrefix = volumeUnits.volumeUnit(for: volumeUnit.type)
            }
            units.append(.size(size, volumePrefix))
        }
        if serving != nil {
            units.append(.serving)
        }
        if canBeMeasuredInWeight {
            units.append(contentsOf: WeightUnit.allCases.map { .weight($0) })
        }
        let volumeTypes: [VolumeUnitType] = [.mL, .liter, .cup, .fluidOunce, .tablespoon, .teaspoon]
        if canBeMeasuredInVolume {
            units.append(contentsOf: volumeTypes.map { .volume(volumeUnits.volumeUnit(for: $0)) })
        }
        return units
    }
}

public extension Food {
    var canBeMeasuredInWeight: Bool {
        if density != nil {
            return true
        }
        
        if amount.isWeightBased(in: self) {
            return true
        }
        if let serving, serving.isWeightBased(in: self) {
            return true
        }
        for size in formSizes {
            if size.isWeightBased {
                return true
            }
        }
        return false
    }
    
    var canBeMeasuredInVolume: Bool {
        if density != nil {
            return true
        }
        
        if amount.isVolumeBased(in: self) {
            return true
        }
        if let serving, serving.isVolumeBased(in: self) {
            return true
        }
        
        //TODO: Copy `isVolumeBased` etc to FoodQuantity.Size and use foodQuantitySizes here instead (and remove formSizes)
        for size in formSizes {
            if size.isVolumeBased {
                return true
            }
        }
        return false
    }
    
    var onlySupportsWeights: Bool {
        canBeMeasuredInWeight
        && !canBeMeasuredInVolume
        && serving == nil
        && sizes.isEmpty
    }
    
    var onlySupportsVolumes: Bool {
        canBeMeasuredInVolume
        && !canBeMeasuredInWeight
        && serving == nil
        && sizes.isEmpty
    }

    var onlySupportsServing: Bool {
        serving != nil
        && !canBeMeasuredInVolume
        && !canBeMeasuredInWeight
        && sizes.isEmpty
    }
}

public extension Food {
    func value(for nutrient: Nutrient) -> NutrientValue? {
        switch nutrient {
        case .energy:
            return NutrientValue(value: energy, energyUnit: energyUnit)
        case .macro(let macro):
            return switch macro {
            case .carb:     NutrientValue(macro: .carb, value: carb)
            case .fat:      NutrientValue(macro: .fat, value: fat)
            case .protein:  NutrientValue(macro: .protein, value: protein)
            }
        case .micro(let micro):
            guard let nutrient = micros.first(where: { $0.micro == micro }) else {
                return nil
            }
            return NutrientValue(nutrient)
        }
    }
}

public extension Food {
    var formSizes: [FormSize] {
        sizes.compactMap { foodSize in
            FormSize(foodSize: foodSize, in: sizes)
        }
    }
}

public extension Food {
    var canBeMeasuredInServings: Bool {
        amount.unitType == .serving
    }
    
    var defaultAmounts: [FoodValue] {
        var amounts: [FoodValue] = []
        if canBeMeasuredInServings {
            amounts.append(.init(1, .serving))
        }
        if canBeMeasuredInWeight {
            amounts.append(.init(100, .weight(.g)))
        }
        if canBeMeasuredInVolume {
            amounts.append(.init(1, .volume(.cupMetric)))
        }
        for size in self.formSizes {
            let amount: FoodValue
            if size.isVolumePrefixed, let volume = size.volumeUnit {
                amount = .init(1, .size(size, volume))
            } else {
                amount = .init(1, .size(size, nil))
            }
            amounts.append(amount)
        }
        return amounts
    }
}

public extension Food {
    func value(for nutrient: Nutrient, with amount: FoodValue) -> Double {
        guard
            let quantity = quantity(for: amount),
            let scaleFactor = nutrientScaleFactor(for: quantity),
            let value = value(for: nutrient)?.value
        else { return 0 }
        
        return value * scaleFactor
    }
}

public extension Food {
    func micros(for amount: FoodValue) -> [FoodNutrient] {
        micros.compactMap { foodNutrient in
            guard let micro = foodNutrient.micro else { return nil }
            let unit = foodNutrient.unit
            let value = calculateMicro(micro, for: amount, in: unit)
            return FoodNutrient(micro: micro, value: value, unit: unit)
        }
    }
}

public extension Food {
    func calculateEnergy(in unit: EnergyUnit, for amount: FoodValue) -> Double {
        guard let value = value(for: .energy) else { return 0 }
        return value.value * nutrientScaleFactor(for: amount)
    }

    func calculateMacro(_ macro: Macro, for amount: FoodValue) -> Double {
        guard let value = value(for: .macro(macro)) else { return 0 }
        return value.value * nutrientScaleFactor(for: amount)
    }

    func calculateMicro(_ micro: Micro, for amount: FoodValue, in unit: NutrientUnit?) -> Double {
        guard let value = value(for: .micro(micro)) else { return 0 }
        
        //TODO: Handle unit conversions
//        let unit = unit ?? micro.defaultUnit
        
        return value.value * nutrientScaleFactor(for: amount)
    }

    private func nutrientScaleFactor(for amount: FoodValue) -> Double {
        guard let quantity = quantity(for: amount) else { return 0 }
        return nutrientScaleFactor(for: quantity) ?? 0
    }
}

public extension Food {
    var units: [FormUnit] {
        var units: [FormUnit] = []
        if canBeMeasuredInWeight {
            units += WeightUnit.primaryUnits.map { .weight($0) }
        }
        if canBeMeasuredInVolume {
            units += VolumeUnit.primaryUnits.map { .volume($0) }
        }
        if canBeMeasuredInServings {
            units.append(.serving)
        }
        units += formSizes.map {
            let volumeUnit: VolumeUnit? = $0.isVolumePrefixed ? .cupMetric : nil
            return .size($0, volumeUnit)
        }
        return units
    }
}

public extension WeightUnit {
    static var primaryUnits: [WeightUnit] {
        [.g, .oz]
    }
}

public extension VolumeUnit {
    static var primaryUnits: [VolumeUnit] {
        //TODO: Use User's specific units here
        [.cupMetric, .tablespoonMetric, .teaspoonMetric, .mL]
    }
}

public extension String {
    static var randomFoodEmoji: String {
        let foodEmojis = "🍇🍈🍉🍊🍋🍌🍍🥭🍎🍏🍐🍑🍒🍓🫐🥝🍅🫒🥥🥑🍆🥔🥕🌽🌶️🫑🥒🥬🥦🧄🧅🍄🥜🫘🌰🍞🥐🥖🫓🥨🥯🥞🧇🧀🍖🍗🥩🥓🍔🍟🍕🌭🥪🌮🌯🫔🥙🧆🥚🍳🥘🍲🫕🥣🥗🍿🧈🧂🥫🍱🍘🍙🍚🍛🍜🍝🍠🍢🍣🍤🍥🥮🍡🥟🥠🥡🦪🍦🍧🍨🍩🍪🎂🍰🧁🥧🍫🍬🍭🍮🍯🍼🥛☕🫖🍵🍶🍾🍷🍸🍹🍺🍻🥂🥃🫗🥤🧋🧃🧉🧊🥢🍽️🍴🥄"
        guard let character = foodEmojis.randomElement() else {
            return "🥕"
        }
        return String(character)
    }
}

public extension Food {
    var macrosChartData: [MacroValue] {
        [
            MacroValue(macro: .carb, value: carb),
            MacroValue(macro: .fat, value: fat),
            MacroValue(macro: .protein, value: protein)
        ]
    }
}
