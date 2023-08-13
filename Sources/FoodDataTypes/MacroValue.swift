import Foundation

public struct MacroValue {
    public var macro: Macro
    public var value: Double
    
    public var kcal: Double {
        macro.kcalsPerGram * value
    }
    
    public init(macro: Macro, value: Double) {
        self.macro = macro
        self.value = value
    }
}
