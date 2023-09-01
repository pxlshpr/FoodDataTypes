import XCTest
@testable import FoodDataTypes

final class FoodDataTypesTests: XCTestCase {
    func testSearchEncoding() throws {
        let banana = SearchWord(
            singular: "banana",
            spellings: ["bananas", "banna", "banan", "bannana", "banane", "banano", "bannas", "banans", "banananes", "bannanas", "bananoes"]
        )

        let apple = SearchWord(
            singular: "apple",
            spellings: ["apples", "aple", "appple", "appl", "aepple", "aples", "appls", "appples", "aeples", "aipple"]
        )

        let bananaTokenFlattened = FlattenedSearchToken(wordID: banana.id, isPinned: true)
        let appleTokenFlattened = FlattenedSearchToken(wordID: apple.id, isPinned: false)

        let flattenedTokens = [bananaTokenFlattened, appleTokenFlattened]
        
        let string = flattenedTokens.asString
        print(string)
    }

    func testSearchDecoding() throws {
        let encoded = "7DADAF16-6828-42BD-BA08-6CA7F8DB17AA 1 | 5AD913A3-CA16-4047-B4D6-ABCFC9D92C30 0"
        let array = encoded.searchTokens
        print("We here")
    }
}
