import Foundation

public enum FoodType: Int, Codable, CaseIterable {
    case food = 1
    case recipe
}

extension FoodType: Identifiable {
    public var id: Int { rawValue }
}

public extension FoodType {
    var systemImage: String {
        switch self {
        case .food:     "carrot"
        case .recipe:   "frying.pan"
        }
    }
    
    var name: String {
        switch self {
        case .food:     "Food"
        case .recipe:   "Recipe"
        }
    }
}

extension FoodType: CustomStringConvertible {
    public var description: String {
        name.lowercased()
    }
}
