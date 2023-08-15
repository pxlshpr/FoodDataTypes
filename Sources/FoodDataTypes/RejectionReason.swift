import Foundation

public enum RejectionReason: Int, CaseIterable, Codable {
    
    case duplicateFood = 1
    case missingNameSource
    case incompleteDetails
    case invalidLink
    
    case invalidNutrientsSource
    case missingNutrientsSource
    
    case incompleteNutrients
    case energyDoesNotEqualMacros
    case nutrientsDoNotMatchSource
    
    case invalidSizes
    case missingSizes
    case missingSizesSource
    
    case missingBarcode
    case missingBarcodeSource
    case invalidBarcode
    
    case missingUnitConversion
    case missingUnitConversionSource
    case invalidUnitConversion
    
    case other
}

public extension RejectionReason {
    var description: String {
        switch self {
            
        case .missingNameSource:
            "Missing source for name"
        case .duplicateFood:
            "Duplicate food"
        case .incompleteDetails:
            "Incomplete Details"
        case .invalidLink:
            "Unsupported source website"

        case .invalidNutrientsSource:
            "Unsupported nutrition label"
        case .missingNutrientsSource:
            "Missing source for nutrients"
        case .incompleteNutrients:
            "Incomplete nutrients"
        case .energyDoesNotEqualMacros:
            "Energy does not equal macros"
        case .nutrientsDoNotMatchSource:
            "Nutrients do not match source"
            
        case .invalidBarcode:
            "Invalid barcode"
        case .missingBarcodeSource:
            "Missing source for barcode"
        case .missingBarcode:
            "Missing barcode"

        case .invalidSizes:
            "Invalid sizes"
        case .missingSizes:
            "Missing sizes"
        case .missingSizesSource:
            "Missing source for sizes"
            
        case .missingUnitConversion:
            "Missing unit conversion"
        case .invalidUnitConversion:
            "Invalid unit conversion"
        case .missingUnitConversionSource:
            "Missing source for unit conversion"
        
        case .other:
            "Other (see notes)"
        }
    }
    
    var group: RejectionReasonGroup {
        switch self {
        case .missingNutrientsSource, .incompleteNutrients, .energyDoesNotEqualMacros, .nutrientsDoNotMatchSource:
                .nutrients
        case .duplicateFood, .missingNameSource, .invalidLink, .invalidNutrientsSource, .incompleteDetails:
                .food
        case .invalidSizes, .missingSizes, .missingSizesSource:
                .sizes
        case .missingBarcode, .missingBarcodeSource, .invalidBarcode:
                .barcode
        case .missingUnitConversion, .missingUnitConversionSource, .invalidUnitConversion:
                .unitConversion
        case .other:
                .other
        }
    }
}
