import Foundation

public struct DefaultsKeys {
    public static let latestModificationDate = "latestModificationDate"
    public static let didCreateDatasetFoodsSubscription = "didCreateDatasetFoodsSubscription"
}

public func setLatestModificationDate(_ date: Date) {
    PublicStore.logger.info("⏱️ Setting latestModificationDate to \(date)")
    UserDefaults.standard.setValue(date.timeIntervalSince1970, forKey: DefaultsKeys.latestModificationDate)
}

public func setLatestModificationDate(_ unixTime: Double) {
    UserDefaults.standard.setValue(unixTime, forKey: DefaultsKeys.latestModificationDate)
}

public var latestModificationDate: Date? {
    let timeInterval = UserDefaults.standard.double(forKey: DefaultsKeys.latestModificationDate)
    guard timeInterval != 0 else { return nil }
    return Date(timeIntervalSince1970: timeInterval)
}
