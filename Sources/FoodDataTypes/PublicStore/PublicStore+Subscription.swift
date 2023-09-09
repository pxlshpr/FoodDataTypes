import CloudKit
import OSLog

private let logger = Logger(subsystem: "PublicStore", category: "Subscription")

extension PublicStore {
    func setupSubscription() {
        guard !UserDefaults.standard.bool(forKey: DefaultsKeys.didCreateDatasetFoodsSubscription) else {
            PublicDatabase.fetchAllSubscriptions { subscriptions, error in
                print("We here")
            }
            return
        }
        
        let subscription = CKQuerySubscription(
            recordType: RecordType.datasetFood.name,
            predicate: NSPredicate(value: true),
            subscriptionID: RecordType.datasetFood.subscriptionName,
            options: [.firesOnRecordCreation, .firesOnRecordUpdate]
        )
        
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "" /// this is probably not needed, test without it
        notification.shouldSendContentAvailable = true
        subscription.notificationInfo = notification
        
        Task {
            do {
                let _ = try await PublicDatabase.save(subscription)
                logger.info("DatasetFoods subscription saved")
                UserDefaults.standard.setValue(true, forKey: DefaultsKeys.didCreateDatasetFoodsSubscription)
            } catch {
                logger.error("Error saving subscription: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
}

extension RecordType {
    var subscriptionName: String {
        "\(self.name)-changes"
    }
}
