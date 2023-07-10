import Foundation

public extension Micro {
    
    /// Taken from: https://www.fda.gov/media/135301/download, unless marked
    var dailyValue: (Double, NutrientUnit)? {
        switch self {
        case .saturatedFat:
            return nil
        case .monounsaturatedFat:
            return nil
        case .polyunsaturatedFat:
            return nil
        case .transFat:
            return (0, .g)
            
        case .cholesterol:
            return nil
            
        case .dietaryFiber:
            return nil
//            return (28, .g)
            
        case .solubleFiber:
            /// "with about one-fourth — 6 to 8 grams per day — coming from soluble fiber." https://www.ucsfhealth.org/education/increasing-fiber-intake
//            return (7, .g)
            return nil
            
        case .insolubleFiber:
            /// "with about one-fourth — 6 to 8 grams per day — coming from soluble fiber." https://www.ucsfhealth.org/education/increasing-fiber-intake
//            return (21, .g)
            return nil
            
        case .sugars:
            return (0, .g)
            
        case .addedSugars:
            return (0, .g)
            
        case .sugarAlcohols:
            return (0, .g)
            
        case .calcium:
            return (1300, .mg)
        case .chloride:
            return (2300, .mg)
        case .chromium:
            return (35, .mcg)
        case .copper:
            return (0.9, .mg)
        case .iodine:
            return (150, .mcg)
        case .iron:
            return (18, .mg)
        case .magnesium:
            /// https://www.hsph.harvard.edu/nutritionsource/magnesium/
            return (400, .mg)
        case .manganese:
            /// https://www.hsph.harvard.edu/nutritionsource/manganese/
            return (2.3, .mg)
        case .molybdenum:
            return (45, .mcg)
        case .phosphorus:
            /// https://www.hsph.harvard.edu/nutritionsource/phosphorus/
            return (700, .mg)
        case .potassium:
            /// https://www.hsph.harvard.edu/nutritionsource/potassium/
            return (3400, .mg)
        case .selenium:
            return (55, .mcg)
        case .sodium:
            /// https://www.hsph.harvard.edu/nutritionsource/salt-and-sodium/
            return (500, .mg)
        case .zinc:
            return (11, .mg)
        case .vitaminA:
            return (900, .mcgRAE)
        case .vitaminB6_pyridoxine:
            return (1.7, .mg)
        case .vitaminB12_cobalamin:
            return (2.4, .mcg)
        case .vitaminC_ascorbicAcid:
            return (90, .mg)
        case .vitaminD_calciferol:
            return (20, .mcg)
        case .vitaminE:
            return (15, .mgAT)
        case .vitaminK1_phylloquinone:
            return (120, .mcg)
        case .vitaminB7_biotin:
            return (30, .mcg)
        case .choline:
            return (550, .mg)
        case .vitaminB9_folate:
            return (400, .mcgDFE)
        case .vitaminB3_niacin:
            return (16, .mgNE)
        case .vitaminB5_pantothenicAcid:
            return (5, .mg)
        case .vitaminB2_riboflavin:
            return (1.3, .mg)
        case .vitaminB1_thiamine:
            return (1.2, .mg)
        case .caffeine:
            return (0, .mg)
        case .ethanol:
            return nil
        case .vitaminB9_folicAcid:
            return (400, .mcg)
        case .vitaminK2_menaquinone:
            /// https://futureyouhealth.com/knowledge-centre/vitamin-k2-benefits
            return (100, .mcg)
        case .taurine:
            return nil
        case .polyols:
            return nil
        case .gluten:
            return nil
        case .starch:
            return nil
        case .creatine:
            return (3, .g)
            
        case .salt:
            /// https://www.hsph.harvard.edu/nutritionsource/salt-and-sodium/
            /// "It is estimated that we need about 500 mg of sodium daily for these vital functions" `500 x 2.5 = 1,250 mg`
            return (1.25, .g)
        default:
            return nil
        }
    }
    
    /// Taken from: https://www.fda.gov/media/135301/download, unless marked
    var dailyValueMax: (Double, NutrientUnit)? {
        switch self {
        case .saturatedFat:
//            return (20, .g)
            return nil
            
        case .monounsaturatedFat:
            /// https://news.christianacare.org/2013/04/nutrition-numbers-revealed-fat-intake/
//            return (44, .g)
            return nil
            
        case .polyunsaturatedFat:
            /// https://news.christianacare.org/2013/04/nutrition-numbers-revealed-fat-intake/
//            return (22, .g)
            return nil

        case .transFat:
            /// https://www.who.int/news-room/questions-and-answers/item/nutrition-trans-fat
            return (2.2, .g)
            
        case .cholesterol:
            return nil
//            return (300, .mg)
            
        case .dietaryFiber:
            /// https://www.integratedeating.com/blog/2020/9/21/myth-there-is-no-such-thing-as-too-much-fiber
//            return (70, .g)
            return nil
            
        case .solubleFiber:
//            return (17.5, .g)
            return nil
            
        case .insolubleFiber:
//            return (52.5, .g)
            return nil
            
        case .sugars:
            /// Adding `.addedSugars` + free sugars [from here](https://www.nhs.uk/live-well/eat-well/food-types/how-does-sugar-in-our-diet-affect-our-health/)
//            return nil
            return (80, .g)
            
        case .addedSugars:
            return (50, .g)
        case .sugarAlcohols:
            /// https://www.goodrx.com/well-being/diet-nutrition/what-are-sugar-alcohols-and-are-they-healthy
            return (20, .g)
            
        case .calcium:
            /// https://www.hsph.harvard.edu/nutritionsource/calcium/
            return (2500, .mg)
        case .chloride:
            /// https://www.eufic.org/en/vitamins-and-minerals/article/chloride-foods-functions-how-much-do-you-need-more
            return (3100, .mg)
        case .chromium:
            /// https://www.webmd.com/diet/supplement-guide-chromium
            return (1000, .mcg)
        case .copper:
            /// https://www.hsph.harvard.edu/nutritionsource/copper/
            return (10, .mg)
        case .iodine:
            /// https://www.hsph.harvard.edu/nutritionsource/iodine/
            return (1100, .mcg)
        case .iron:
            /// https://www.hsph.harvard.edu/nutritionsource/iron/
            return (45, .mg)
        case .magnesium:
            /// https://hvmn.com/blogs/blog/supplements-magnesium-supplement-guide
            return (750, .mg)
        case .manganese:
            /// https://www.hsph.harvard.edu/nutritionsource/manganese/
            return (11, .mg)
        case .molybdenum:
            /// https://www.hsph.harvard.edu/nutritionsource/molybdenum/
            return (2000, .mcg)
        case .phosphorus:
            /// https://www.hsph.harvard.edu/nutritionsource/phosphorus/
            return (4000, .mg)
        case .potassium:
            /// https://www.hsph.harvard.edu/nutritionsource/potassium/
            return (4700, .mg)
        case .selenium:
            /// https://www.hsph.harvard.edu/nutritionsource/selenium/
            return (400, .mcg)
        case .sodium:
            return (2300, .mg)
        case .zinc:
            /// https://www.hsph.harvard.edu/nutritionsource/zinc/
            return (40, .mg)
        case .vitaminA:
            /// https://www.hsph.harvard.edu/nutritionsource/vitamin-a/
            return (3000, .mcgRAE)
        case .vitaminB6_pyridoxine:
            /// https://ods.od.nih.gov/factsheets/VitaminB6-Consumer/
            return (100, .mg)
        case .vitaminB12_cobalamin:
            /// https://www.hsph.harvard.edu/nutritionsource/vitamin-b12/
            return (1000, .mcg)
        case .vitaminC_ascorbicAcid:
            /// https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/expert-answers/vitamin-c/faq-20058030
            return (2000, .mg)
        case .vitaminD_calciferol:
            /// https://www.nhs.uk/conditions/vitamins-and-minerals/vitamin-d/
            return (100, .mcg)
        case .vitaminE:
            /// https://ods.od.nih.gov/factsheets/VitaminE-Consumer/
            return (1000, .mgAT)
        case .vitaminK1_phylloquinone:
            /// https://www.mattilsynet.no/mat_og_vann/spesialmat_og_kosttilskudd/kosttilskudd/assessment_of_dietary_intake_of_vitamin_k_and_maximum_limits_for_vitamin_k_in_food_supplements.29756/binary/Assessment%20of%20dietary%20intake%20of%20vitamin%20K%20and%20maximum%20limits%20for%20vitamin%20K%20in%20food%20supplements
            return (800, .mcg)
        case .vitaminB7_biotin:
            /// https://drformulas.com/blogs/news/5000-mcg-of-biotin-vitamins-safe-for-hair-growth
            return (5000, .mcg)
        case .choline:
            /// https://www.hsph.harvard.edu/nutritionsource/choline/
            return (3500, .mg)
        case .vitaminB9_folate:
            /// https://www.hsph.harvard.edu/nutritionsource/folic-acid/
            return (1000, .mcgDFE)
        case .vitaminB3_niacin:
            /// https://www.hsph.harvard.edu/nutritionsource/niacin-vitamin-b3/
            return (35, .mgNE)
        case .vitaminB5_pantothenicAcid:
            /// https://www.webmd.com/vitamins/ai/ingredientmono-853/pantothenic-acid-vitamin-b5
            return (1000, .g)
        case .vitaminB2_riboflavin:
            /// https://www.webmd.com/vitamins/ai/ingredientmono-957/riboflavin
            return (400, .mg)
        case .vitaminB1_thiamine:
            /// https://lpi.oregonstate.edu/mic/vitamins/thiamin
            return (200, .mg)
        case .caffeine:
            /// https://www.hsph.harvard.edu/nutritionsource/caffeine/
            /// https://myhealth.alberta.ca/Alberta/Pages/Substance-use-caffeine.aspx
            return (600, .mg)
        case .ethanol:
            return nil
        case .vitaminB9_folicAcid:
            /// https://www.hsph.harvard.edu/nutritionsource/folic-acid/
            return (1000, .mcg)
        case .vitaminK2_menaquinone:
            /// https://futureyouhealth.com/knowledge-centre/vitamin-k2-benefits
            return (300, .mcg)
        case .taurine:
            return nil
        case .polyols:
            return nil
        case .gluten:
            return nil
        case .starch:
            return nil
        case .salt:
            /// multiplying sodium by 2.5
            return (5.75, .g)
        case .creatine:
            return (5, .g)
            
        default:
            return nil
        }
    }
    
    /**
     Converts a % RDA value to an amount
     */
    func convertRDApercentage(_ percentage: Double) -> (amount: Double, NutrientUnit)? {
        guard let dailyValue = dailyValue else {
            return nil
        }
        return ((dailyValue.0) * percentage / 100.0, dailyValue.1)
    }
}
