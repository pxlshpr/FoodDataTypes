import Foundation

public enum NutrientUnit: Int, CaseIterable, Codable {
    case g = 1
    case mg
    case mgAT /// alpha-tocopherol
    case mgNE
    case mcg = 50
    case mcgDFE
    case mcgRAE
    case IU = 100
    case p /// percent
    case kcal = 200
    case kJ
    
    /// Used by USDA
    case pH = 300
    case SG
    case mcmolTE
    case mgGAE
}

public extension NutrientUnit {
    var abbreviation: String {
        switch self {
        case .g:        "g"
        case .mg:       "mg"
        case .mgAT:     "mgAT"
        case .mgNE:     "mgNE"
        case .mcg:      "mcg"
        case .mcgDFE:   "mcgDFE"
        case .mcgRAE:   "mcgRAE"
        case .IU:       "IU"
        case .p:        "p"
        case .kcal:     "kcal"
        case .kJ:       "kJ"
        case .pH:       "pH"
        case .SG:       "SG"
        case .mcmolTE:  "mcmolTE"
        case .mgGAE:    "mgGAE"
        }
    }
}

public extension NutrientUnit {
    var foodLabelUnit: FoodLabelUnit? {
        switch self {
        case .g:
            return .g
        case .mcg, .mcgDFE, .mcgRAE:
            return .mcg
        case .mg, .mgAT, .mgNE:
            return .mg
        case .p:
            return .p
        case .IU:
            return .iu
        case .kcal:
            return .kcal
        case .kJ:
            return .kj
                        
        /// Used by the USDA Database
        case .pH, .SG, .mcmolTE, .mgGAE:
            return nil
        }
    }
    
    var energyUnit: EnergyUnit? {
        switch self {
        case .kcal: .kcal
        case .kJ:   .kJ
        default:    nil
        }
    }
}

public extension NutrientUnit {
    
    //TODO: Write tests for these
    
    func convert(_ amount: Double, to unit: FoodLabelUnit) -> Double {
        var scale: Double {
            switch self {
            case .g:
                switch unit {
                case .mcg:
                    return 1000000
                case .mg:
                    return 1000
                case .oz:
                    return 0.035274
                case .g:
                    return 1
                default:
                    return 0
                }
            case .mg, .mgAT, .mgNE, .mgGAE:
                switch unit {
                case .mcg:
                    return 1000
                case .mg:
                    return 1
                case .oz:
                    return 0.00003527
                case .g:
                    return 0.001
                default:
                    return 0
                }
            case .mcg, .mcgDFE, .mcgRAE:
                switch unit {
                case .mcg:
                    return 1
                case .mg:
                    return 0.001
                case .oz:
                    return 0.000000035274
                case .g:
                    return 0.000001
                default:
                    return 0
                }
            case .kcal:
                switch unit {
                case .kj:
                    return KjPerKcal
                default:
                    return 0
                }
            case .kJ:
                switch unit {
                case .kcal:
                    return 1.0/KjPerKcal
                default:
                    return 0
                }
            case .IU:
                //TODO: Handle this
                return 0
            default:
                return 0
            }
        }
        
        return amount * scale
    }
}
