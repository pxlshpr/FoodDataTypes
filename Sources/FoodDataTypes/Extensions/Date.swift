import Foundation

public extension Array where Element == Date? {
    var latestDate: Date? {
        self.compactMap { $0 }
            .sorted()
            .last
    }
}
