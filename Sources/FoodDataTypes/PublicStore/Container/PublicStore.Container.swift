import Foundation
import CoreData

extension PublicStore {
    class Container: NSPersistentContainer {
        init() {
            guard
                let url = Bundle.main.url(forResource: "DatasetFoods", withExtension: "momd"),
                let objectModel = NSManagedObjectModel(contentsOf: url)
            else {
                fatalError("Failed to retrieve the object model")
            }
            super.init(name: "DatasetFoods", managedObjectModel: objectModel)
            
            self.initialize()
        }
        
        private func initialize() {

            guard let _ = self.persistentStoreDescriptions.first else {
                fatalError()
            }
          
            self.loadPersistentStores { description, error in
                guard let error = error as NSError? else { return }
                fatalError("Failed to load CoreData: \(error)")
            }
        }
        
        func save() throws {
            try self.viewContext.save()
        }
    }
}

extension PublicStore.Container {
    
    func loadSQLiteDatabase(_ databaseFile: String) {
        guard let prepopulateURL = Bundle.main.url(
            forResource: databaseFile,
            withExtension: "sqlite"
        ) else {
            fatalError()
        }

        replacePersisteStore(with: prepopulateURL)
    }
    
    func replacePersisteStore(with url: URL) {
        guard let storeURL = self.persistentStoreDescriptions.first?.url else {
            fatalError()
        }
        
        do {
            
            try self.persistentStoreCoordinator.replacePersistentStore(
                at: storeURL,
                withPersistentStoreFrom: url,
                ofType: NSSQLiteStoreType
            )
        } catch {
        }
    }
}
