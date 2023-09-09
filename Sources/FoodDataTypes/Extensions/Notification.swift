import Foundation

public extension Notification.Name {

    static var didUpdateFood: Notification.Name { return .init("didUpdateFood") }
    static var didUpdateWord: Notification.Name { return .init("didUpdateWord") }
}

public extension Notification {
    enum Keys: String {
        case food = "food"
    }
}

public func post(_ name: Notification.Name, _ userInfo: [Notification.Keys : Any]? = nil) {
    NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
}

public extension Notification {
    func value(for key: Notification.Keys) -> Any? {
        userInfo?[key]
    }
    
    var food: Food? {
        value(for: .food) as? Food
    }
}
