import Foundation
import CloudKit

public let BarcodesSeparator = "¦"
public let SpellingsSeparator = " ¦ "

//public let SearchTokensSeparator = " ¦ "

public extension CKRecord {
    subscript(key: PublicFoodKeys) -> CKRecordValue? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    
    subscript(key: PublicSearchWordKeys) -> CKRecordValue? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    
    subscript(key: PublicKeys) -> CKRecordValue? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
}

public extension CKRecord {
    var id: UUID? {
        guard let string = self[.id] as? String else { return nil }
        return UUID(uuidString: string)
    }
    var updatedAt: Date? { self[.updatedAt] as? Date }
    var createdAt: Date? { self[.createdAt] as? Date }
    var isTrashed: Bool? { self[.isTrashed] as? Bool }
}

/// `Food` specific
public extension CKRecord {
    var emoji: String? { self[.emoji] as? String }
    var name: String? { self[.name] as? String }
    var detail: String? { self[.detail] as? String }
    var brand: String? { self[.brand] as? String }
    var datasetID: String? { self[.datasetID] as? String }
    var url: String? { self[.url] as? String }
    var ownerID: String? { self[.ownerID] as? String }
    var reviewerID: String? { self[.reviewerID] as? String }
    var rejectionNotes: String? { self[.rejectionNotes] as? String }

    var amount: FoodValue? {
        guard let data = self[.amountData] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodValue.self, from: data)
    }
    var serving: FoodValue? {
        guard let data = self[.servingData] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodValue.self, from: data)
    }
    var previewAmount: FoodValue? {
        guard let data = self[.previewAmountData] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodValue.self, from: data)
    }
    var micros: [FoodNutrient]? {
        guard let data = self[.microsData] as? Data else { return nil }
        return try? JSONDecoder().decode([FoodNutrient].self, from: data)
    }
    var sizes: [FoodSize]? {
        guard let data = self[.sizesData] as? Data else { return nil }
        return try? JSONDecoder().decode([FoodSize].self, from: data)
    }
    
    var rejectionReasons: [RejectionReason]? {
        guard let data = self[.rejectionReasonsData] as? Data else { return nil }
        return try? JSONDecoder().decode([RejectionReason].self, from: data)
    }

    var density: FoodDensity? {
        guard let data = self[.densityData] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodDensity.self, from: data)
    }
    var barcodes: [String] {
        guard let string = self[.barcodesString] as? String else { return [] }
        return string.components(separatedBy: BarcodesSeparator)
    }

    var searchTokens: [FlattenedSearchToken] {
        guard let string = self[.searchTokensString] as? String else { return [] }
        return string.searchTokens
    }

    var energy: Double? { self[.energy] as? Double }
    var carb: Double? { self[.carb] as? Double }
    var protein: Double? { self[.protein] as? Double }
    var fat: Double? { self[.fat] as? Double }

    var energyUnit: EnergyUnit? {
        guard let rawValue = self[.energyUnitValue] as? Int else { return nil }
        return EnergyUnit(rawValue: rawValue)
    }
    var publishStatus: PublishStatus? {
        guard let rawValue = self[.publishStatusValue] as? Int else { return nil }
        return PublishStatus(rawValue: rawValue)
    }
    var type: FoodType? {
        guard let rawValue = self[.typeValue] as? Int else { return nil }
        return FoodType(rawValue: rawValue)
    }
    var dataset: FoodDataset? {
        guard let rawValue = self[.datasetValue] as? Int else { return nil }
        return FoodDataset(rawValue: rawValue)
    }
}

/// `SearchWord` specific
public extension CKRecord {
    var singular: String? { self[.singular] as? String }
    var spellings: [String] {
        guard let string = self[.spellingsString] as? String else { return [] }
        return string.components(separatedBy: SpellingsSeparator)
    }
}
