import Foundation

public extension String {
    var detectedValuesForScanner: [FoodLabelValue] {
        FoodLabelValue.detect(in: self, forScanner: true)
    }
    
    var detectedValues: [FoodLabelValue] {
        FoodLabelValue.detect(in: self, forScanner: false)
    }
}
