import CoreData
import SwiftSugar

public extension NSManagedObjectContext {
    func performInBackgroundAndMergeWithMainContext(
        mainContext: NSManagedObjectContext,
        posting notificationName: Notification.Name? = nil,
        performBlock: @escaping () -> ()
    ) async {
        await performInBackgroundContextAndMergeWithMainContext(
            bgContext: self,
            mainContext: mainContext,
            posting: notificationName,
            performBlock: performBlock
        )
    }
}

public func performInBackgroundContextAndMergeWithMainContext(
    bgContext: NSManagedObjectContext,
    mainContext: NSManagedObjectContext,
    posting notificationName: Notification.Name? = nil,
    performBlock: @escaping () -> ()
) async {
    await performInBackgroundContextAndMergeWithMainContext(
        bgContext: bgContext,
        mainContext: mainContext,
        performBlock: performBlock,
        didSaveHandler: {
            if let notificationName {
                post(notificationName)
            }
        }
    )
}

public func performInBackgroundContextAndMergeWithMainContext(
    bgContext: NSManagedObjectContext,
    mainContext: NSManagedObjectContext,
    performBlock: @escaping () throws -> (),
    didSaveHandler: @escaping () -> (),
    errorHandler: (() -> ())? = nil
) async {
    await bgContext.perform {
        
        do {
            try performBlock()
        } catch {
            errorHandler?()
        }
        
        do {
            let observer = NotificationCenter.default.addObserver(
                forName: .NSManagedObjectContextDidSave,
                object: bgContext,
                queue: .main
            ) { (notification) in
                mainContext.mergeChanges(fromContextDidSave: notification)
                didSaveHandler()
            }
            
            try bgContext.performAndWait {
                try bgContext.save()
            }
            NotificationCenter.default.removeObserver(observer)

        } catch {
            //TODO: Handle CoreData error here
        }
    }
}
