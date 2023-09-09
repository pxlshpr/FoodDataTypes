import Foundation

import SwiftSugar

/**
 A value that can appear in a Food Label.
 
 This comprises of an amount and an optional `FoodLabelUnit`.
 */
public struct FoodLabelValue: Codable {
    public var amount: Double
    public var unit: FoodLabelUnit?
    
    public init(amount: Double, unit: FoodLabelUnit? = nil) {
        self.amount = amount
        self.unit = unit
    }
}

extension FoodLabelValue: Equatable {
    public static func ==(lhs: FoodLabelValue, rhs: FoodLabelValue) -> Bool {
        lhs.amount == rhs.amount &&
        lhs.unit == rhs.unit
    }
}

extension FoodLabelValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(unit)
    }
}


public extension FoodLabelValue {
    
    var hasEnergyUnit: Bool {
        guard let unit = unit else { return false }
        return unit.isEnergy
    }
    
    var hasNutrientUnit: Bool {
        guard let unit = unit else { return false }
        return unit.isNutrientUnit
    }
    
    var isReferenceEnergyValue: Bool {
        if amount == 8400, unit == .kj {
            return true
        }
        if amount == 2000, unit == .kcal {
            return true
        }
        return false
    }
    
    static func haveValues(in string: String) -> Bool {
        detect(in: string).count > 0
    }
}

extension FoodLabelValue: CustomStringConvertible {
    public var description: String {
        if let unit = unit {
            return "\(amount.cleanAmount) \(unit.description)"
        } else {
            return "\(amount.cleanAmount)"
        }
    }
    
    public var descriptionWithoutRounding: String {
        if let unit = unit {
            return "\(amount.cleanWithoutRounding) \(unit.description)"
        } else {
            return "\(amount.cleanWithoutRounding)"
        }
    }
}

public extension FoodLabelValue {
    var energyAmountInCalories: Double {
        if let unit = unit, unit == .kj {
            return EnergyUnit.kJ.convert(amount, to: .kcal)
        } else {
            /// We're making the assumption that no unit implies it's in `kcal`
            return amount
        }
    }
    var energyAmountInKilojoules: Double {
        if let unit = unit, unit == .kj {
            return amount
        } else {
            /// We're making the assumption that no unit implies it's in `kcal`
            return EnergyUnit.kcal.convert(amount, to: .kJ)
        }
    }
}

//MARK: - Regex

extension FoodLabelValue {
    public init?(fromString string: String) {
        
        /// Special cases
        let str = string.trimmingWhitespaces.lowercased()
        if str == "nil" || str == "not detected" {
            self.amount = 0
            //            self.unit = .g
            return
        } else if str == "trace" {
            self.amount = 0.08
            self.unit = .g
            //            self.unit = .g
            return
        }
        
        let groups = string.capturedGroups(using: Regex.fromString, allowCapturingEntireString: true)
        guard groups.count > 1 else {
            return nil
        }
        
        var cleanedAmount = groups[1]
            .replacingOccurrences(of: ":", with: ".") /// Fix Vision errors of misreading decimal places as `:`
        
        /// Special case when we misread something like `0.8 ug` as `08 ug`
        if let singleDigitPrefixedByZero = cleanedAmount.firstCapturedGroup(using: #"^0([0-9])$"#) {
            cleanedAmount = "0.\(singleDigitPrefixedByZero)"
        }
        
        if cleanedAmount.matchesRegex(NumberRegex.usingCommaAsDecimalPlace) {
            cleanedAmount = cleanedAmount.replacingOccurrences(of: ",", with: ".")
        } else {
            /// It's been used as a thousand separator in that case
            cleanedAmount = cleanedAmount.replacingOccurrences(of: ",", with: "")
        }
        
        guard let amount = Double(cleanedAmount) else {
            return nil
        }
        self.amount = amount
        if groups.count == 3 {
            guard let unit = FoodLabelUnit(string: groups[2].lowercased().trimmingWhitespaces) else {
                return nil
            }
            self.unit = unit
        } else {
            self.unit = nil
        }
    }
    
    public struct Regex {
        public static let units = FoodLabelUnit.allUnits.map { #"[ ]*\#($0)"# }.joined(separator: "|")
        public static let number = #"[0-9]+[0-9.:,]*"#
        public static let atStartOfString = #"^(?:(\#(number)(?:(?:\#(units)(?: |\)|$))| |$)*(?: |\)|\/|$))|nil(?: |$)|trace(?: |$))"#
        public static let atStartOfString_legacy2 = #"^(?:(\#(number)(?:(?:\#(units)(?: |\)|$))| |$))|nil(?: |$)|trace(?: |$))"#
        public static let atStartOfString_legacy1 = #"^(\#(number)(?:(?:\#(units)(?: |\)|$))| |$))"#
        public static let fromString = #"^(\#(number))(?:(\#(units)(?: |\)|$))| |\/|$)"#
        
        //TODO: Remove this
        public static let standardPattern =
        #"^(?:[^0-9.:]*(?: |\()|^\/?)([0-9.:]+)[ ]*(\#(units))+(?: .*|\).*$|\/?$)$"#
    }
    
    public static var DisqualifyingTexts: [String] = [
        "contributes to a daily diet",
        "daily value",
        "produced for",
        "keep frozen",
        "best before",
        "ingredients"
//        "of which"
    ]
}

//MARK: - Detect

public extension FoodLabelValue {
    
    ///Prioritises value with unit if only 1 is found, otherwise returning the first value
    static func detectSingleValue(in string: String) -> FoodLabelValue? {
        let values = Self.detect(in: string)
        if values.containingUnit.count == 1 {
            return values.containingUnit.first
        } else {
            return values.first
        }
    }

    static func detect(in string: String, forScanner: Bool = true) -> [FoodLabelValue] {
        detect(in: string, withPositions: false, forScanner: forScanner).map { $0.0 }
    }
    
    /// Detects `Value`s in a provided `string` in the order that they appear
    static func detect(in string: String, withPositions: Bool, forScanner: Bool = true) -> [(FoodLabelValue, Int)] {
        
        var string = string
        /// Add regex to check if we have "Not detected" or "nil" and replace with 0 (no unit)
//        if string.matchesRegex("(not detected|nil)") {
//            return [(Value(amount: 0), 0), (Value(amount: 0), 1)]
//        }
//
//        /// Or if we have "trace" replace it with 0.05 (no unit)
//        if string.matchesRegex("(trace)") {
//            return [(Value(amount: 0.05), 0)]
//        }
        
        /// We invalidate these only for the `FoodLabelScanner` as they interfere with our tabular approach—so set this flag to `false` if you need to strictly grab all the values
        if forScanner {
            /// Invalidates strings like `20 g = 3`
            if string.matchesRegex(#"[0-9]+[ ]*[A-z]*[ ]*=[ ]*[0-9]+"#) {
                return []
            }
            
            /// Invalidates strings like `5 x 3`
            if string.matchesRegex(#"[0-9]+[ ]*x[ ]*[0-9]+"#) {
                return []
            }
        }

        for disqualifyingText in FoodLabelValue.DisqualifyingTexts {
            guard !(string.lowercased().contains(disqualifyingText)) else {
                return []
            }
        }
        
        /// Commented out in favor of the function based approach below (with additional ones with spaces)
//        if string.hasSuffix("Og") {
//            string = string.replacingLastOccurrence(of: "Og", with: "0g")
//        }
//        if string.hasSuffix("Omg") {
//            string = string.replacingLastOccurrence(of: "Omg", with: "0mg")
//        }
//        if string.hasSuffix("Omcg") {
//            string = string.replacingLastOccurrence(of: "Omcg", with: "0mcg")
//        }
        //TODO: Use regex for these, also include ones with simple "o"
        func suffixReplace(_ incorrects: [String], with correct: String) {
            for incorrect in incorrects {
                if string.hasSuffix(incorrect) {
                    string = string.replacingLastOccurrence(of: incorrect, with: correct)
                    break
                }
            }
        }
        suffixReplace(["Og", "O g"], with: "0g")
        suffixReplace(["Omg", "O mg"], with: "0mg")
        suffixReplace(["Omcg", "O mcg"], with: "0mcg")

        
        func replace(_ incorrects: [String], with correct: String) {
            for incorrect in incorrects {
                if string == incorrect {
                    string = correct
                    break
                }
            }
        }
//        if string == "O" {
//            string = "0"
//        }
        replace(["O"], with: "0")
        replace(["O a"], with: "0g")

        /// Replaces fractional values with their true values
        string = string.replacingOccurrences(of: "1/2", with: "0.5")
        string = string.replacingOccurrences(of: "1/3", with: "0.3333")
        string = string.replacingOccurrences(of: "1/4", with: "0.25")
        string = string.replacingOccurrences(of: "1/5", with: "0.2")

        /// If we encouner strings such as `(%5 (A pall clues )) a` — which is usually how daily values in arabic is read—don't extract values from it
//        guard !string.matchesRegex("%[0-9]+") else {
//            return []
//        }
        
        var array: [(value: FoodLabelValue, positionOfMatch: Int)] = []
//        cprint("🔢      👁 detecting values in: \(string)")

        let specialValuesArray = [
            "(?<!not detected )(?:not detected)",
            "(?:not detected)(?! not detected )",
            "nil",
            "trace"
        ]
        let specialValues = #"(\#(specialValuesArray.joined(separator: "|")))"#
        let regex = #"(?:([0-9]+[0-9.,]*[ ]*(?:\#(FoodLabelValue.Regex.units)|)(?:[^A-z0-9]|]|$))|\#(specialValues))"#
//        let regex = #"(?:([^A-z]|^)([0-9]+[0-9.,]*[ ]*(?:\#(Value.Regex.units)|)(?:[^A-z0-9]|]|$))|\#(specialValues))"#
        if let matches = string.matches(for: regex), !matches.isEmpty {
            
            for match in matches {
                guard let value = FoodLabelValue(fromString: match.string) else {
//                    cprint("🔢      👁   - '\(match.string)' @ \(match.position): ⚠️ Couldn't get value")
                    continue
                }
//                cprint("🔢      👁   - '\(match.string)' @ \(match.position): \(value.description)")
                array.append((value, match.position))
            }
        }
        
        array.sort(by: { $0.positionOfMatch < $1.positionOfMatch })
        return array
    }

}


public extension FoodLabelValue {
    mutating func correctUnit(for attribute: Attribute) {
        guard let unit else {
            self.unit = attribute.defaultUnit
            return
        }
        
        if !attribute.supportsUnit(unit) {
            self.unit = attribute.defaultUnit
        }
        return
    }
}
