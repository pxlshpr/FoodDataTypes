import Foundation
import CloudKit

public let BarcodesSeparator = "¦"

extension CKRecord {
    var id: UUID? {
        guard let string = self[PublicFoodKeys.id.rawValue] as? String else { return nil }
        return UUID(uuidString: string)
    }
    var emoji: String? { self[PublicFoodKeys.emoji.rawValue] as? String }
    var name: String? { self[PublicFoodKeys.name.rawValue] as? String }
    var detail: String? { self[PublicFoodKeys.detail.rawValue] as? String }
    var brand: String? { self[PublicFoodKeys.brand.rawValue] as? String }
    var datasetID: String? { self[PublicFoodKeys.datasetID.rawValue] as? String }
    var url: String? { self[PublicFoodKeys.url.rawValue] as? String }
    var ownerID: String? { self[PublicFoodKeys.ownerID.rawValue] as? String }

    var amount: FoodValue? {
        guard let data = self[PublicFoodKeys.amountData.rawValue] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodValue.self, from: data)
    }
    var serving: FoodValue? {
        guard let data = self[PublicFoodKeys.servingData.rawValue] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodValue.self, from: data)
    }
    var previewAmount: FoodValue? {
        guard let data = self[PublicFoodKeys.previewAmountData.rawValue] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodValue.self, from: data)
    }
    var micros: [FoodNutrient]? {
        guard let data = self[PublicFoodKeys.microsData.rawValue] as? Data else { return nil }
        return try? JSONDecoder().decode([FoodNutrient].self, from: data)
    }
    var sizes: [FoodSize]? {
        guard let data = self[PublicFoodKeys.sizesData.rawValue] as? Data else { return nil }
        return try? JSONDecoder().decode([FoodSize].self, from: data)
    }
    var density: FoodDensity? {
        guard let data = self[PublicFoodKeys.densityData.rawValue] as? Data else { return nil }
        return try? JSONDecoder().decode(FoodDensity.self, from: data)
    }
    var barcodes: [String] {
        guard let string = self[PublicFoodKeys.barcodesString.rawValue] as? String else { return [] }
        return string.components(separatedBy: BarcodesSeparator)
    }

    var energy: Double? { self[PublicFoodKeys.energy.rawValue] as? Double }
    var carb: Double? { self[PublicFoodKeys.carb.rawValue] as? Double }
    var protein: Double? { self[PublicFoodKeys.protein.rawValue] as? Double }
    var fat: Double? { self[PublicFoodKeys.fat.rawValue] as? Double }

    var energyUnit: EnergyUnit? {
        guard let rawValue = self[PublicFoodKeys.energyUnitValue.rawValue] as? Int else { return nil }
        return EnergyUnit(rawValue: rawValue)
    }
    var publishStatus: PublishStatus? {
        guard let rawValue = self[PublicFoodKeys.publishStatusValue.rawValue] as? Int else { return nil }
        return PublishStatus(rawValue: rawValue)
    }
    var type: FoodType? {
        guard let rawValue = self[PublicFoodKeys.typeValue.rawValue] as? Int else { return nil }
        return FoodType(rawValue: rawValue)
    }
    var dataset: FoodDataset? {
        guard let rawValue = self[PublicFoodKeys.datasetValue.rawValue] as? Int else { return nil }
        return FoodDataset(rawValue: rawValue)
    }
    
    var updatedAt: Date? { self[PublicFoodKeys.updatedAt.rawValue] as? Date }
    var createdAt: Date? { self[PublicFoodKeys.createdAt.rawValue] as? Date }

    var isTrashed: Bool? { self[PublicFoodKeys.isTrashed.rawValue] as? Bool }

}
