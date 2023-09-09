import Foundation

public enum RejectionReasonGroup: CaseIterable {
    case food
    //    case source
    case nutrients
    case sizes
    case barcode
    case unitConversion
    case other
}

public extension RejectionReasonGroup {
    var name: String? {
        switch self {
        case .food:             nil
        case .nutrients:        "Nutrients"
        case .sizes:            "Sizes"
        case .barcode:          "Barcode"
        case .unitConversion:   "Unit Conversion"
        case .other:            nil
        }
    }
    
    var reasons: [RejectionReason] {
        RejectionReason.allCases
            .filter { $0.group == self }
            .sorted { $0.description < $1.description }
    }
}
