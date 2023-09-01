import Foundation

public enum PublicFoodKeys: String {
    case id
    case name
    case detail
    case brand
    case emoji
    case typeValue
    case energy
    case energyUnitValue
    case carb
    case fat
    case protein
    case microsData
    case amountData
    case servingData
    case densityData
    case previewAmountData
    case sizesData
    case barcodesString
    case url
    case ownerID
    case publishStatusValue
    case datasetValue
    case datasetID
    case createdAt
    case updatedAt
    case isTrashed
    
    case ingredients
    
    case image1
    case image2
    case image3
    case image4
    case image5
    
    case rejectionReasonsData
    case rejectionNotes
    case reviewerID
    case searchTokensString
}

import CloudKit

public extension CKRecord {
    subscript(key: PublicFoodKeys) -> CKRecordValue? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
}

public extension PublicFoodKeys {
    
    static var desiredKeysAsStrings: [String] {
        desiredKeys.map { $0.rawValue }
    }
    
    static var desiredKeys: [PublicFoodKeys] {
        [
            .id,
            .name,
            .detail,
            .brand,
            .emoji,
            .typeValue,
            .energy,
            .energyUnitValue,
            .carb,
            .fat,
            .protein,
            .microsData,
            .amountData,
            .servingData,
            .densityData,
            .previewAmountData,
            .sizesData,
            .barcodesString,
            .url,
            .ownerID,
            .publishStatusValue,
            .datasetValue,
            .datasetID,
            .createdAt,
            .updatedAt,
            .isTrashed,
            .ingredients,
            .rejectionReasonsData,
            .rejectionNotes,
            .reviewerID,
            .searchTokensString
        ]
    }
}
