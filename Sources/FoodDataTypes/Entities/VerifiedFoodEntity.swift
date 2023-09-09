import Foundation
import CoreData
import CloudKit
import OSLog
import UIKit

private let logger = Logger(subsystem: "FoodEntity", category: "")

@objc(VerifiedFoodEntity)
public class VerifiedFoodEntity: NSManagedObject, Identifiable, Entity {

}

extension VerifiedFoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VerifiedFoodEntity> {
        return NSFetchRequest<VerifiedFoodEntity>(entityName: "VerifiedFoodEntity")
    }

    @NSManaged public var amountData: Data?
    @NSManaged public var barcodesString: String?
    @NSManaged public var brand: String?
    @NSManaged public var carb: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var datasetID: String?
    @NSManaged public var datasetValue: Int16
    @NSManaged public var densityData: Data?
    @NSManaged public var detail: String?
    @NSManaged public var emoji: String?
    @NSManaged public var energy: Double
    @NSManaged public var energyUnitValue: Int16
    @NSManaged public var fat: Double
    @NSManaged public var hasAwardedCredits: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var image1: Data?
    @NSManaged public var image2: Data?
    @NSManaged public var image3: Data?
    @NSManaged public var image4: Data?
    @NSManaged public var image5: Data?
    @NSManaged public var isSynced: Bool
    @NSManaged public var isTrashed: Bool
    @NSManaged public var lastAmountData: Data?
    @NSManaged public var microsData: Data?
    @NSManaged public var name: String?
    @NSManaged public var ownerID: String?
    @NSManaged public var previewAmountData: Data?
    @NSManaged public var protein: Double
    @NSManaged public var publishStatusValue: Int16
    @NSManaged public var rejectionNotes: String?
    @NSManaged public var rejectionReasonsData: Data?
    @NSManaged public var reviewerID: String?
    @NSManaged public var searchTokensString: String?
    @NSManaged public var servingData: Data?
    @NSManaged public var sizesData: Data?
    @NSManaged public var typeValue: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var url: String?
    @NSManaged public var newVersion: VerifiedFoodEntity?
    @NSManaged public var oldVersion: VerifiedFoodEntity?
}


public extension Food {
    
    init(_ entity: VerifiedFoodEntity) {
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
            url: entity.url,
            barcodes: entity.barcodes,
            type: entity.type,
            publishStatus: entity.publishStatus,
            dataset: entity.dataset,
            datasetID: entity.datasetID,
            lastAmount: entity.lastAmount,
            updatedAt: entity.updatedAt ?? entity.createdAt!,
            createdAt: entity.createdAt!,
            isTrashed: entity.isTrashed,
//            childrenFoodItems: entity.ingredientItems,
            childrenFoodItems: [],
            ownerID: entity.ownerID,
            rejectionReasons: entity.rejectionReasons,
            rejectionNotes: entity.rejectionNotes,
            reviewerID: entity.reviewerID,
            searchTokens: entity.searchTokens
        )
    }
}

public extension VerifiedFoodEntity {
    
    convenience init(_ record: CKRecord, _ context: NSManagedObjectContext) {
        self.init(context: context)
        self.fill(with: record)
    }
    
    func fill(with record: CKRecord) {
        self.id = record.id!
        self.emoji = record.emoji!
        self.name = record.name!
        self.detail = record.detail
        self.brand = record.brand
        self.amount = record.amount!
        self.serving = record.serving
        self.previewAmount = record.previewAmount
        self.energy = record.energy!
        self.energyUnit = record.energyUnit!
        self.carb = record.carb!
        self.protein = record.protein!
        self.fat = record.fat!
        self.micros = record.micros!
        self.sizes = record.sizes!
        self.density = record.density
        self.url = record.url
        self.barcodes = record.barcodes
        self.type = record.type!
        self.publishStatus = record.publishStatus
        self.dataset = record.dataset
        self.datasetID = record.datasetID
        self.updatedAt = record.updatedAt!
        self.createdAt = record.createdAt!
        self.isTrashed = record.isTrashed!
        self.ownerID = record.ownerID
        
        self.reviewerID = record.reviewerID
        self.rejectionReasons = record.rejectionReasons
        self.rejectionNotes = record.rejectionNotes
        self.searchTokens = record.searchTokens
        
        logger.debug("    filled info")

        if let url = (record["image1"] as? CKAsset)?.fileURL {
            image1 = try! Data(contentsOf: url)
            logger.debug("    filled image1")
        }
        if let url = (record["image2"] as? CKAsset)?.fileURL {
            image2 = try! Data(contentsOf: url)
            logger.debug("    filled image2")
        }
        if let url = (record["image3"] as? CKAsset)?.fileURL {
            image3 = try! Data(contentsOf: url)
            logger.debug("    filled image3")
        }
        if let url = (record["image4"] as? CKAsset)?.fileURL {
            image4 = try! Data(contentsOf: url)
            logger.debug("    filled image4")
        }
        if let url = (record["image5"] as? CKAsset)?.fileURL {
            image5 = try! Data(contentsOf: url)
            logger.debug("    filled image5")
        }
    }
}

public extension VerifiedFoodEntity {
    
    var barcodes: [String] {
        get {
            guard let barcodesString else { return [] }
            return barcodesString
                .components(separatedBy: BarcodesSeparator)
        }
        set {
            self.barcodesString = newValue
                .joined(separator: BarcodesSeparator)
        }
    }
    
    var searchTokens: [FlattenedSearchToken] {
        get {
            guard let searchTokensString else { return [] }
            return searchTokensString.searchTokens
        }
        set {
            self.searchTokensString = newValue.asString
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
    
    var lastAmount: FoodValue? {
        get {
            guard let lastAmountData else {
                return nil
            }
            return try! JSONDecoder().decode(FoodValue.self, from: lastAmountData)
        }
        set {
            if let newValue {
                self.lastAmountData = try! JSONEncoder().encode(newValue)
            } else {
                self.lastAmountData = nil
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

    var publishStatus: PublishStatus? {
        get {
            PublishStatus(rawValue: Int(publishStatusValue))
        }
        set {
            if let newValue {
                publishStatusValue = Int16(newValue.rawValue)
            } else {
                publishStatusValue = 0
            }
        }
    }
    
    var rejectionReasons: [RejectionReason]? {
        get {
            guard let rejectionReasonsData else { return nil }
            return try! JSONDecoder().decode([RejectionReason].self, from: rejectionReasonsData)
        }
        set {
            if let newValue {
                self.rejectionReasonsData = try! JSONEncoder().encode(newValue)
            } else {
                self.rejectionReasonsData = nil
            }
        }
    }
}

public extension VerifiedFoodEntity {
    var images: [UIImage] {
        let imageData = [image1, image2, image3, image4, image5].compactMap { $0 }
        var images: [UIImage] = []
        for data in imageData {
            guard let image = UIImage(data: data) else {
                fatalError()
            }
            images.append(image)
        }
        return images
    }
}

public extension CKRecord {
    func update(with foodEntity: VerifiedFoodEntity) {
        self[.publishStatusValue] = foodEntity.publishStatusValue as CKRecordValue
        self[.rejectionReasonsData] = foodEntity.rejectionReasonsData as? CKRecordValue
        self[.rejectionNotes] = foodEntity.rejectionNotes as? CKRecordValue
        self[.reviewerID] = foodEntity.reviewerID as? CKRecordValue
        self[.searchTokensString] = foodEntity.searchTokensString as? CKRecordValue
        self[.isTrashed] = foodEntity.isTrashed as CKRecordValue
        self[.updatedAt] = Date.now as CKRecordValue
    }
}
