import Foundation
import CoreData
import CloudKit

let FoodsPageSize = 1000
let SearchWordPageSize = 50

@objc(SearchWordEntity)
public class SearchWordEntity: NSManagedObject, Identifiable, Entity { }

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

public extension SearchWordEntity {
    convenience init(context: NSManagedObjectContext, fields: SearchWordFields) {
        self.init(context: context)
        self.id = UUID()
        self.createdAt = Date.now
        self.updatedAt = Date.now
        self.isTrashed = false
        self.isSynced = false
        self.fill(fields: fields)
    }
    
    convenience init(_ record: CKRecord, _ context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = record.id
        self.singular = record.singular
        self.spellings = record.spellings
        self.createdAt = record.createdAt
        self.updatedAt = record.updatedAt
        self.isTrashed = record.isTrashed ?? false

        self.isSynced = true
    }
    
    func fill(fields: SearchWordFields) {
        self.singular = fields.singular
        self.spellings = fields.spellings
    }
}

public extension SearchWordEntity {
    
    func merge(with record: CKRecord, context: NSManagedObjectContext) {
        
        let previousID = self.id!
        self.id = record.id /// Use the record's ID regardless of how recent our version is

        /// If the record is more recent than this version
        /// *Note: The `updatedAt` time is used instead of CloudKit's `modificationDate`, so that we are comparing
        /// when the records were actually updated on their respective devices, and not when they were saved in CloudKit
        /// (to account for situations such as the network not being available).*
        if record.updatedAt! > self.updatedAt! {
            /// Use all its values, discarding our changes (singular might change too if it had a diacritic)
            self.singular = record.singular
            self.createdAt = record.createdAt
            self.updatedAt = record.updatedAt
            self.isTrashed = record.isTrashed ?? false
            self.spellings = record.spellings

            /// Make sure we're not setting this to be synced any more in case it was set to `false` by changes we have now discarded
            isSynced = true
        } else {
            /// If our version is more recent then we retain any changes we may have made, which will be
            /// subsequently uploaded during the sync.
        }

        /// Replace the ID in any entities that may have used the old ID if it's different to what we have
        if previousID != id {
            DatasetFoodEntity.replaceWordID(previousID, with: record.id!, context: context)
        }
    }
}

public extension SearchWordEntity {
    var spellings: [String] {
        get {
            guard let spellingsString, !spellingsString.isEmpty else { return [] }
            return spellingsString
                .components(separatedBy: SpellingsSeparator)
        }
        set {
            self.spellingsString = newValue
                .joined(separator: SpellingsSeparator)
        }
    }
}

public extension SearchWordEntity {
    var asSearchWord: SearchWord {
        SearchWord(
            id: id!,
            singular: singular!,
            spellings: spellings,
            createdAt: createdAt!,
            updatedAt: updatedAt!
        )
    }
}

public extension SearchWordEntity {

    static func existingWord(matching record: CKRecord, context: NSManagedObjectContext) -> SearchWordEntity? {
        guard let id = record.id?.uuidString, let singular = record.singular else {
            return nil
        }
        let predicates = [
            NSPredicate(format: "id == %@", id),
            NSPredicate(format: "singular ==[cd] %@", singular)
        ]
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        return objects(predicate: predicate, context: context).first
    }
    
    static func fetch(
        matching text: String? = nil,
        page: Int,
        context: NSManagedObjectContext) -> [SearchWordEntity] {
        
        let sortDescriptors = [NSSortDescriptor(keyPath: \SearchWordEntity.singular, ascending: true)]
        
        return SearchWordEntity.objects(
            predicate: fetchPredicate(matching: text),
            sortDescriptors: sortDescriptors,
            fetchLimit: FoodsPageSize,
            fetchOffset: (page - 1) * FoodsPageSize,
            context: context
        )
    }
    
    static func matchPredicate(for text: String) -> NSPredicate {
        let singular = NSPredicate(format: "singular CONTAINS[cd] %@", text)
        let spellings = NSPredicate(format: "spellingsString CONTAINS[cd] %@", text)
        return NSCompoundPredicate(orPredicateWithSubpredicates: [singular, spellings])
    }
    
    static var isNotTrashedPredicate: NSPredicate {
        NSPredicate(format: "isTrashed == NO")
    }
    
    static func fetchPredicate(matching text: String? = nil) -> NSPredicate? {
        guard let text = text?.lowercased() else {
            return isNotTrashedPredicate
        }
        return matchedAndIsNotTrashedPredicate(for: text)
    }
    
    static func matchedAndIsNotTrashedPredicate(for text: String) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [
            matchPredicate(for: text),
            isNotTrashedPredicate
        ])
    }
}


public extension SearchWordEntity {

    static func findWords(matching text: String, context: NSManagedObjectContext) -> [SearchWordEntity] {
        SearchWordEntity.objects(
            predicate: findPredicate(for: text),
            context: context
        ).filter {
            $0.singular == text || $0.spellings.contains(text)
        }
    }
    
    static func findPredicate(for text: String) -> NSPredicate {
        let text = text.lowercased()
        return matchedAndIsNotTrashedPredicate(for: text)
    }
}

public extension SearchWordEntity {
    var asCKRecord: CKRecord {
        
        let record = CKRecord(recordType: RecordType.searchWord.name)

        if let id { record[.id] = id.uuidString as CKRecordValue }
        if let createdAt { record[.createdAt] = createdAt as CKRecordValue }
        if let updatedAt { record[.updatedAt] = updatedAt as CKRecordValue }
        record[.isTrashed] = isTrashed as CKRecordValue

        if let singular { record[.singular] = singular as CKRecordValue }
        if let spellingsString { record[.spellingsString] = spellingsString as CKRecordValue }
        
        return record
    }
}

public extension CKRecord {
    func update(withSearchWordEntity entity: SearchWordEntity) {
        /// Make sure the `id` of the `CKRecord` never changes
        self[.singular] = entity.singular! as CKRecordValue
        if let spellingsString = entity.spellingsString {
            self[.spellingsString] = spellingsString as CKRecordValue
        } else {
            self[.spellingsString] = nil
        }
        self[.isTrashed] = entity.isTrashed as CKRecordValue
        self[.updatedAt] = entity.updatedAt! as CKRecordValue
    }
}