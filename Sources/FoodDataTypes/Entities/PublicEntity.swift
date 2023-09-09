import Foundation

public protocol PublicEntity: Entity {
    var updatedAt: Date? { get set }
    var isSynced: Bool { get set }
}

public extension PublicEntity {
    func setAsUpdated() {
        self.updatedAt = Date.now
        self.isSynced = false
    }
}
