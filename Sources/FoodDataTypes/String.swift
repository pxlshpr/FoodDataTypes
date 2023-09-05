import Foundation

public extension String {
    var detectedValuesForScanner: [FoodLabelValue] {
        FoodLabelValue.detect(in: self, forScanner: true)
    }
    
    var detectedValues: [FoodLabelValue] {
        FoodLabelValue.detect(in: self, forScanner: false)
    }
}

public extension String {
    
    func sanitizedSearchWord() -> String {
        let invalidCharacters = CharacterSet
            .whitespacesAndNewlines
            .union(.controlCharacters)
            .union(.illegalCharacters)
            .union(.decimalDigits)
            .union(.punctuationCharacters)
            .union(.symbols)
        return self
            .lowercased()
            .components(separatedBy: invalidCharacters)
            .joined()
    }
    
    var searchWords: [String] {
//        self
//            .replacingOccurrences(of: ",", with: " ")
//            .replacingOccurrences(of: ".", with: " ")
//            .components(separatedBy: " ")
//            .map { $0.replacingOccurrences(of: " ", with: "") } /// handles double, triple, etc whitespaces
//            .compactMap { $0.isEmpty ? nil : $0 }
        
        self
            .components(separatedBy: " ")
            .map { $0.sanitizedSearchWord() }
            .compactMap { $0.isEmpty ? nil : $0 }
    }
}
