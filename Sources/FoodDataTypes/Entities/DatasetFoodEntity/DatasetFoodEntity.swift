import Foundation
import CoreData

@objc(DatasetFoodEntity)
public class DatasetFoodEntity: NSManagedObject, Identifiable, PublicEntity { }

extension DatasetFoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DatasetFoodEntity> {
        return NSFetchRequest<DatasetFoodEntity>(entityName: "DatasetFoodEntity")
    }

    @NSManaged public var id: UUID?

    @NSManaged public var name: String?
    @NSManaged public var emoji: String?
    @NSManaged public var detail: String?
    @NSManaged public var brand: String?

    @NSManaged public var amountData: Data?
    @NSManaged public var servingData: Data?
    @NSManaged public var previewAmountData: Data?
    
    @NSManaged public var energy: Double
    @NSManaged public var energyUnitValue: Int16
    @NSManaged public var carb: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double

    @NSManaged public var microsData: Data?
    @NSManaged public var sizesData: Data?
    @NSManaged public var densityData: Data?

    @NSManaged public var barcodesString: String?
    @NSManaged public var searchTokensString: String?

    @NSManaged public var typeValue: Int16
    @NSManaged public var datasetID: String?
    @NSManaged public var datasetValue: Int16

    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isSynced: Bool
    @NSManaged public var isTrashed: Bool
    
    @NSManaged public var newVersion: DatasetFoodEntity?
    @NSManaged public var oldVersion: DatasetFoodEntity?

}

public extension DatasetFoodEntity {
    func contains(wordID: UUID) -> Bool {
        searchTokens.contains(where: { $0.wordID == wordID })
    }
    func removeSearchToken(wordID: UUID) {
        searchTokens.removeAll(where: { $0.wordID == wordID })
    }
    
    func setSearchToken(wordID: UUID, rank: SearchRank) {
        removeSearchToken(wordID: wordID)
        searchTokens.append(.init(wordID: wordID, rank: rank))
    }
}

public extension DatasetFoodEntity {
    static func replaceWordID(_ old: UUID, with new: UUID, context: NSManagedObjectContext) {
        DatasetFoodEntity.objects(
            predicate: NSPredicate(format: "searchTokensString CONTAINS %@", old.uuidString),
            context: context
        ).forEach { entity in
            entity.replaceWordID(old, with: new)
        }
    }
    
    func replaceWordID(_ old: UUID, with new: UUID) {
        guard let index = searchTokens.firstIndex(where: { $0.wordID == old }) else {
            return
        }
        searchTokens[index].wordID = new
    }
}

public extension DatasetFoodEntity {
    
    var searchTokens: [FlattenedSearchToken] {
        get {
            guard let searchTokensString else { return [] }
            return searchTokensString.searchTokens
        }
        set {
            self.searchTokensString = newValue.asString
        }
    }
    
    var barcodes: [String] {
        get {
            guard let barcodesString, !barcodesString.isEmpty else { return [] }
            return barcodesString
                .components(separatedBy: BarcodesSeparator)
        }
        set {
            self.barcodesString = newValue
                .joined(separator: BarcodesSeparator)
        }
    }

    var amount: FoodValue {
        get {
            guard let amountData else {
                fatalError()
            }
            return try! JSONDecoder().decode(FoodValue.self, from: amountData)
        }
        set {
            self.amountData = try! JSONEncoder().encode(newValue)
        }
    }

    var micros: [FoodNutrient] {
        get {
            guard let microsData else { fatalError() }
            return try! JSONDecoder().decode([FoodNutrient].self, from: microsData)
        }
        set {
            self.microsData = try! JSONEncoder().encode(newValue)
        }
    }

    var sizes: [FoodSize] {
        get {
            guard let sizesData else { fatalError() }
            return try! JSONDecoder().decode([FoodSize].self, from: sizesData)
        }
        set {
            self.sizesData = try! JSONEncoder().encode(newValue)
        }
    }

    var serving: FoodValue? {
        get {
            guard let servingData else {
                return nil
            }
            return try! JSONDecoder().decode(FoodValue.self, from: servingData)
        }
        set {
            if let newValue {
                self.servingData = try! JSONEncoder().encode(newValue)
            } else {
                self.servingData = nil
            }
        }
    }
    
    var previewAmount: FoodValue? {
        get {
            guard let previewAmountData else {
                return nil
            }
            return try! JSONDecoder().decode(FoodValue.self, from: previewAmountData)
        }
        set {
            if let newValue {
                self.previewAmountData = try! JSONEncoder().encode(newValue)
            } else {
                self.previewAmountData = nil
            }
        }
    }
    
    var density: FoodDensity? {
        get {
            guard let densityData else { return nil }
            return try! JSONDecoder().decode(FoodDensity.self, from: densityData)
        }
        set {
            if let newValue {
                self.densityData = try! JSONEncoder().encode(newValue)
            } else {
                self.densityData = nil
            }
        }
    }

    var energyUnit: EnergyUnit {
        get {
            EnergyUnit(rawValue: Int(energyUnitValue)) ?? .kcal
        }
        set {
            energyUnitValue = Int16(newValue.rawValue)
        }
    }

    var type: FoodType {
        get {
            FoodType(rawValue: Int(typeValue)) ?? .food
        }
        set {
            typeValue = Int16(newValue.rawValue)
        }
    }

    var dataset: FoodDataset? {
        get {
            FoodDataset(rawValue: Int(datasetValue))
        }
        set {
            if let newValue {
                datasetValue = Int16(newValue.rawValue)
            } else {
                datasetValue = 0
            }
        }
    }
}

public extension Food {
    init(_ entity: DatasetFoodEntity) {
        self.init(
            id: entity.id!,
            emoji: entity.emoji!,
            name: entity.name!,
            detail: entity.detail,
            brand: entity.brand,
            amount: entity.amount,
            serving: entity.serving,
            previewAmount: entity.previewAmount,
            energy: entity.energy,
            energyUnit: entity.energyUnit,
            carb: entity.carb,
            protein: entity.protein,
            fat: entity.fat,
            micros: entity.micros,
            sizes: entity.sizes,
            density: entity.density,
            barcodes: entity.barcodes,
            type: entity.type,
            dataset: entity.dataset,
            datasetID: entity.datasetID,
            updatedAt: entity.updatedAt ?? entity.createdAt!,
            createdAt: entity.createdAt!,
            isTrashed: entity.isTrashed,
            childrenFoodItems: [],
            ownerID: nil,
            searchTokens: entity.searchTokens
        )
    }
}

import CloudKit

public extension DatasetFoodEntity {
    var asCKRecord: CKRecord {
        
        let record = CKRecord(recordType: RecordType.datasetFood.name)

        if let id { record[.id] = id.uuidString as CKRecordValue }
        if let name { record[.name] = name as CKRecordValue }
        if let detail { record[.detail] = detail as CKRecordValue }
        if let brand { record[.brand] = brand as CKRecordValue }
        if let emoji { record[.emoji] = emoji as CKRecordValue }

        record[.energy] = energy as CKRecordValue
        record[.energyUnitValue] = energyUnitValue as CKRecordValue
        record[.carb] = carb as CKRecordValue
        record[.fat] = fat as CKRecordValue
        record[.protein] = protein as CKRecordValue
        if let microsData { record[.microsData] = microsData as CKRecordValue }
        if let amountData { record[.amountData] = amountData as CKRecordValue }
        if let servingData { record[.servingData] = servingData as CKRecordValue }
        if let densityData { record[.densityData] = densityData as CKRecordValue }
        if let previewAmountData { record[.previewAmountData] = previewAmountData as CKRecordValue }
        if let sizesData { record[.sizesData] = sizesData as CKRecordValue }
        
        if let barcodesString { record[.barcodesString] = barcodesString as CKRecordValue }
        if let searchTokensString { record[.searchTokensString] = searchTokensString as CKRecordValue }

        if let createdAt { record[.createdAt] = createdAt as CKRecordValue }
        if let updatedAt { record[.updatedAt] = updatedAt as CKRecordValue }
        record[.isTrashed] = isTrashed as CKRecordValue

        record[.datasetValue] = datasetValue as CKRecordValue
        if let datasetID { record[.datasetID] = datasetID as CKRecordValue }
        
        return record
    }
}

public extension DatasetFoodEntity {
    func fill(food: Food) {
        id = food.id
        name = food.name
        detail = food.detail
        brand = food.brand
        emoji = food.emoji
        energy = food.energy
        energyUnit = food.energyUnit
        amount = food.amount
        serving = food.serving
        carb = food.carb
        fat = food.fat
        protein = food.protein
        micros = food.micros
        previewAmount = food.previewAmount
        sizes = food.sizes
        barcodes = food.barcodes
        searchTokens = food.searchTokens
        dataset = food.dataset
        datasetID = food.datasetID
        createdAt = food.createdAt
        updatedAt = food.updatedAt
        isTrashed = food.isTrashed
    }
}
