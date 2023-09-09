import Foundation
import CoreData

@objc(SearchWordEntity)
public class SearchWordEntity: NSManagedObject, Identifiable { }

extension SearchWordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchWordEntity> {
        return NSFetchRequest<SearchWordEntity>(entityName: "SearchWordEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isSynced: Bool
    @NSManaged public var isTrashed: Bool
    @NSManaged public var singular: String?
    @NSManaged public var spellingsString: String?
    @NSManaged public var updatedAt: Date?

}

//extension SearchWordEntity : Identifiable { }
