import XCTest
@testable import FoodDataTypes

final class FoodDataTypesTests: XCTestCase {
    func testSearchEncoding() throws {
        let banana = SearchWord(
            singular: "banana",
            plural: "bananas",
            misspellings: ["banna", "banan", "bannana", "banane", "banano", "bannas", "banans", "banananes", "bannanas", "bananoes"]
        )

        let apple = SearchWord(
            singular: "apple",
            plural: "apples",
            misspellings: ["aple", "appple", "appl", "aepple", "aples", "appls", "appples", "aeples", "aipple"]
        )

        let bananaToken = SearchToken(word: banana, rank: 1)
        let appleToken = SearchToken(word: apple, rank: 0)
        
        let tokens = SearchTokens(tokens: [bananaToken, appleToken])
        print(tokens.asString)
    }

    func testSearchDecoding() throws {
        let encoded = "banana ¦ bananas ¦ banna , banan , bannana , banane , banano , bannas , banans , banananes , bannanas , bananoes | 1 ; apple ¦ apples ¦ aple , appple , appl , aepple , aples , appls , appples , aeples , aipple | 0"
        let tokens = SearchTokens(from: encoded)
        print("We here")
    }
}
