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
}
