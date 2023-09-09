import Foundation

public enum RecordType {
    case subscriptionCredits
    case verifiedFood
    case datasetFood
    case searchWord
}

public extension RecordType {
    var name: String {
        switch self {
        case .subscriptionCredits:  "SubscriptionCredits"
        case .verifiedFood:         "VerifiedFood"
        case .datasetFood:          "DatasetFood"
        case .searchWord:           "SearchWord"
        }
    }
}
