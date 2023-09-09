import Foundation

public enum PublishStatus: Int, Codable {
    case hidden = 1
    
    case pendingReview
    case inReview
    case revoked
    
    case verified = 100
    
    case rejected = 200
}
