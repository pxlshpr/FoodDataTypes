import XCTest
@testable import FoodDataTypes

final class FoodDataTypesTests: XCTestCase {
    func testSearchTokenRepresentation() throws {
        let word = SearchWord(
            singular: "banana",
            plural: "bananas",
            misspellings: ["banna", "banan", "bannana", "banane", "banano", "bannas", "banans", "banananes", "bannanas", "bananoes"]
        )
        
        let token = SearchToken(word: word, rank: 1)
        let jsonData = try! JSONEncoder().encode(token)
        guard let string = String(data: jsonData, encoding: String.Encoding.utf8) else {
            fatalError()
        }
        print(string)
        
        let dataFromString = Data(string.utf8)
        let decodedToken = try! JSONDecoder().decode(SearchToken.self, from: dataFromString)
        print("decodedToken: \(decodedToken)")
        print("")
    }
}
