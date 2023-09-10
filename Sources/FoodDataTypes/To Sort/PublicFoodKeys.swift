import Foundation

public enum PublicKeys: String, CaseIterable {
    case id
    case createdAt
    case updatedAt
    case isTrashed
    
    static var keysAsStrings: [String] {
        allCases.map { $0.rawValue }
    }
}

public enum PublicSearchWordKeys: String {
    case singular
    case spellingsString
}

public enum PublicFoodKeys: String {
    case name
    case emoji
    case detail
    case brand

    case amountData
    case servingData
    case previewAmountData

    case energy
    case energyUnitValue
    case carb
    case fat
    case protein

    case microsData
    case sizesData
    case densityData

    case barcodesString
    case searchTokensString

    case typeValue
    case ingredients
    
    /// DatasetFood specific
    case datasetValue
    case datasetID

    /// VerifiedFood specific
    case url
    case ownerID
    case publishStatusValue
    case rejectionReasonsData
    case rejectionNotes
    case reviewerID
    case image1
    case image2
    case image3
    case image4
    case image5
}

import CloudKit

public extension PublicFoodKeys {
    static var desiredKeysForDatasetFoods: [CKRecord.FieldKey] {
        datasetFoodKeys.map { $0.rawValue } + PublicKeys.keysAsStrings
    }
    
    static func desiredKeysForVerifiedFoods(withImages: Bool) -> [CKRecord.FieldKey] {
        verifiedFoodKeys(withImages: withImages).map { $0.rawValue } + PublicKeys.keysAsStrings
    }
}

extension PublicFoodKeys {
    
    static var baseKeys: [PublicFoodKeys] {
        [
            .name,
            .emoji,
            .detail,
            .brand,

            .amountData,
            .servingData,
            .previewAmountData,

            .energy,
            .energyUnitValue,
            .carb,
            .fat,
            .protein,

            .microsData,
            .sizesData,
            .densityData,

            .barcodesString,
            .searchTokensString,

            .typeValue,
            .ingredients,
        ]
    }
    
    static var datasetFoodKeys: [PublicFoodKeys] {
        baseKeys
        +
        [
            .datasetValue,
            .datasetID,
        ]
    }
    
    static func verifiedFoodKeys(withImages: Bool) -> [PublicFoodKeys] {
        var keys = baseKeys
        +
        [
            .url,
            .ownerID,
            .publishStatusValue,
            .rejectionReasonsData,
            .rejectionNotes,
            .reviewerID,
        ]
        if withImages {
            keys += [
                .image1,
                .image2,
                .image3,
                .image4,
                .image5,
            ]
        }
        return keys
    }
}
