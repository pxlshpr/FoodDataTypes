import CloudKit

public extension Food {
    init(_ record: CKRecord) {
        self.init(
            id: record.id!,
            emoji: record.emoji!,
            name: record.name!,
            detail: record.detail,
            brand: record.brand,
            amount: record.amount!,
            serving: record.serving,
            previewAmount: record.previewAmount,
            energy: record.energy!,
            energyUnit: record.energyUnit!,
            carb: record.carb!,
            protein: record.protein!,
            fat: record.fat!,
            micros: record.micros!,
            sizes: record.sizes!,
            density: record.density,
            url: record.url,
            barcodes: record.barcodes,
            type: record.type ?? .food,
            publishStatus: record.publishStatus,
            dataset: record.dataset,
            datasetID: record.datasetID,
            lastAmount: nil,
            updatedAt: record.updatedAt!,
            createdAt: record.createdAt!,
            isTrashed: record.isTrashed!,
            childrenFoodItems: [],
            ownerID: record.ownerID,
            rejectionReasons: record.rejectionReasons,
            rejectionNotes: record.rejectionNotes,
            reviewerID: record.reviewerID,
            searchTokens: record.searchTokens
        )
    }
}
