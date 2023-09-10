import Foundation
import CoreData
import CloudKit

public extension DatasetFoodEntity {
    
    static var recordType: RecordType { .datasetFood }
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
        type = record.type ?? .food

        datasetID = record.datasetID
        dataset = record.dataset!

        barcodes = record.barcodes
        searchTokens = record.searchTokens

        updatedAt = record.updatedAt!
        createdAt = record.createdAt!
        isTrashed = record.isTrashed ?? false
    }
}

public extension CKRecord {
    func update(withDatasetFoodEntity entity: DatasetFoodEntity) {
        /// Make sure the `id` of the `CKRecord` never changes
        self[.name] = entity.name! as CKRecordValue
        self[.emoji] = entity.emoji! as CKRecordValue
        if let detail = entity.detail {
            self[.detail] = detail as CKRecordValue
        } else {
            self[.detail] = nil
        }
        if let brand = entity.brand {
            self[.brand] = brand as CKRecordValue
        } else {
            self[.brand] = nil
        }
        if let searchTokensString = entity.searchTokensString {
            self[.searchTokensString] = searchTokensString as CKRecordValue
        } else {
            self[.searchTokensString] = nil
        }
        self[.isTrashed] = entity.isTrashed as CKRecordValue
        self[.updatedAt] = entity.updatedAt! as CKRecordValue
    }
}
