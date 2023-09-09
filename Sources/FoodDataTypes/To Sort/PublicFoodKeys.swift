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
//    case id
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
//    case createdAt
//    case updatedAt
//    case isTrashed
    
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

public extension PublicFoodKeys {
    
    static var desiredKeysAsStrings: [String] {
        desiredKeys.map { $0.rawValue }
        + PublicKeys.keysAsStrings
    }
    
    static var desiredKeys: [PublicFoodKeys] {
        [
//            .id,
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
//            .createdAt,
//            .updatedAt,
//            .isTrashed,
            .ingredients,
            .rejectionReasonsData,
            .rejectionNotes,
            .reviewerID,
            .searchTokensString
        ]
    }
}