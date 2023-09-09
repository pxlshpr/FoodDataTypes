import Foundation

public func searchFoodsPredicate(_ wordResults: [FindWordResult]) -> NSPredicate {
    
    var wordPredicates: [NSPredicate] = []
    for wordIDArray in wordResults.wordIDArrays {
        var predicates: [NSPredicate] = []
        for wordID in wordIDArray {
            predicates.append(NSPredicate(format: "searchTokensString CONTAINS[cd] %@", wordID.uuidString))
        }
        /// *OR* the possible `SearchWord.id`s found for each word in the search text
        wordPredicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: predicates))
    }
    
    let words: NSPredicate?
    words = if !wordPredicates.isEmpty {
        /// *AND* the predicates for each word in the search text to ensure they are all present in the results
        NSCompoundPredicate(andPredicateWithSubpredicates: wordPredicates)
    } else {
        nil
    }

    var metadataPredicates: [NSPredicate] = []
    for unrecognizedWord in wordResults.unrecognizedWords {
        let name = NSPredicate(format: "name CONTAINS[cd] %@", unrecognizedWord)
        let detail = NSPredicate(format: "detail CONTAINS[cd] %@", unrecognizedWord)
        let brand = NSPredicate(format: "brand CONTAINS[cd] %@", unrecognizedWord)
        metadataPredicates.append(NSCompoundPredicate(
            orPredicateWithSubpredicates: [name, detail, brand]
        ))
    }
    let metadata: NSPredicate?
    metadata = if !metadataPredicates.isEmpty {
        NSCompoundPredicate(andPredicateWithSubpredicates: metadataPredicates)
    } else {
        nil
    }

    let subpredicates = [metadata, words].compactMap { $0 }
    let isMatch = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
    
    let notSoftDeleted = NSPredicate(format: "isTrashed == NO")
    
    let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        isMatch,
        notSoftDeleted
    ])
    
    return predicate
}

public func wordFormFoodsPredicate(_ fields: SearchWordFields) -> NSPredicate {
    var metadataPredicates: [NSPredicate] = []
    let spellings = fields.spellings + [fields.singular]
    for spelling in spellings {
        let name = NSPredicate(format: "name BEGINSWITH[cd] %@", spelling)
        let detail = NSPredicate(format: "detail BEGINSWITH[cd] %@", spelling)
        let brand = NSPredicate(format: "brand BEGINSWITH[cd] %@", spelling)
        metadataPredicates.append(NSCompoundPredicate(
            orPredicateWithSubpredicates: [name, detail, brand]
        ))
    }
    let metadata: NSPredicate?
    metadata = if !metadataPredicates.isEmpty {
        NSCompoundPredicate(orPredicateWithSubpredicates: metadataPredicates)
    } else {
        nil
    }

    let subpredicates = [metadata].compactMap { $0 }
    let isMatch = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
    
    let notSoftDeleted = NSPredicate(format: "isTrashed == NO")
    
    let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        isMatch,
        notSoftDeleted
    ])
    
    return predicate
}
