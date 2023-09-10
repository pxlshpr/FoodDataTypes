import Foundation
import CoreData
import CloudKit

public extension VerifiedFoodEntity {
    
    static var recordType: RecordType { .verifiedFood }
    static var notificationName: Notification.Name { .didUpdateFood }

    static func object(matching record: CKRecord, context: NSManagedObjectContext) -> NSManagedObject? {
        object(with: record.id!, in: context)
    }
    
    func fill(with record: CKRecord) {
        
        id = record.id!
        
        name = record.name!
        emoji = record.emoji!
        detail = record.detail
        brand = record.brand
        
        amount = record.amount!
        serving = record.serving
        previewAmount = record.previewAmount
        
        energy = record.energy!
        energyUnit = record.energyUnit!
        carb = record.carb!
        fat = record.fat!
        protein = record.protein!
        
        micros = record.micros!
        sizes = record.sizes!
        density = record.density
        type = record.type!

        datasetID = record.datasetID
        dataset = record.dataset

        barcodes = record.barcodes
        searchTokens = record.searchTokens

        updatedAt = record.updatedAt!
        createdAt = record.createdAt!
        isTrashed = record.isTrashed ?? false

        url = record.url
        publishStatus = record.publishStatus
        ownerID = record.ownerID
        
        reviewerID = record.reviewerID
        rejectionReasons = record.rejectionReasons
        rejectionNotes = record.rejectionNotes
        
        if let url = (record["image1"] as? CKAsset)?.fileURL {
            image1 = try! Data(contentsOf: url)
        }
        if let url = (record["image2"] as? CKAsset)?.fileURL {
            image2 = try! Data(contentsOf: url)
        }
        if let url = (record["image3"] as? CKAsset)?.fileURL {
            image3 = try! Data(contentsOf: url)
        }
        if let url = (record["image4"] as? CKAsset)?.fileURL {
            image4 = try! Data(contentsOf: url)
        }
        if let url = (record["image5"] as? CKAsset)?.fileURL {
            image5 = try! Data(contentsOf: url)
        }
    }
}
