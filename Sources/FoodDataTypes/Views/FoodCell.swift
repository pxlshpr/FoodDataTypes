import SwiftUI

import Charts

public struct FoodCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let food: Food
    
    let emoji: String
    let name: String
    let detail: String?
    let brand: String?
    let carb: Double
    let fat: Double
    let protein: Double

    let showsPublishMetadata: Bool
    
    public init(food: Food, showsPublishMetadata: Bool = false) {
        self.food = food
        self.showsPublishMetadata = showsPublishMetadata
        
        self.emoji = food.emoji
        self.name = food.name
        self.detail = food.detail
        self.brand = food.brand
        self.carb = food.carb
        self.fat = food.fat
        self.protein = food.protein
    }

    public var body: some View {
        HStack {
//            notificationBadge
            emojiText
            nameTexts
            publishStatusBadge
            Spacer()
            pieChart
        }
    }
    
    @ViewBuilder
    var notificationBadge: some View {
        if showsPublishMetadata, food.isPendingNotification {
            Circle()
                .foregroundStyle(Color.red)
                .frame(width: 10, height: 10)
        }
    }

    var publishStatusBadge: some View {
        
        return Group {
            if showsPublishMetadata, food.publishStatus != .hidden {
                switch food.publishStatus {
                case .pendingReview:
                    Text("In Review")
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            Capsule()
                                .foregroundStyle(Color(.systemGray6))
                        )
                case .verified:
                    if food.isPendingNotification {
                        Text("Verified")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(
                                Capsule()
                                    .foregroundStyle(Color.green)
                            )
                    }
                  case .rejected:
                    if food.isPendingNotification {
                        Text("Rejected")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(
                                Capsule()
                                    .foregroundStyle(Color.red)
                            )
                    }
                default:
                    EmptyView()
                }
            }
        }
    }

    var greyColor: Color { Color(hex: "6F7E88") }

    @ViewBuilder
    var pieChart: some View {
        if !(carb == 0 && protein == 0 && fat == 0) {
            macrosChart
        } else {
            emptyChart
        }
    }
    
    var emptyChart: some View {
        var chartData: [MacroValue] {
            [
                MacroValue(macro: .carb, value: 100)
            ]
        }

        return Chart(chartData, id: \.macro) { macroValue in
            SectorMark(
                angle: .value("kcal", macroValue.kcal),
                innerRadius: .ratio(0.5),
                angularInset: 0.5
            )
            .cornerRadius(3)
            .foregroundStyle(by: .value("Macro", macroValue.macro))
        }
        .chartForegroundStyleScale([Macro.carb : greyColor])
        .chartLegend(.hidden)
        .frame(width: 28, height: 28)
    }
    
    var macrosChart: some View {
        var chartData: [MacroValue] {
            [
                MacroValue(macro: .carb, value: carb),
                MacroValue(macro: .fat, value: fat),
                MacroValue(macro: .protein, value: protein)
            ]
        }

        return Chart(chartData, id: \.macro) { macroValue in
            SectorMark(
                angle: .value("kcal", macroValue.kcal),
                innerRadius: .ratio(0.5),
                angularInset: 0.5
            )
            .cornerRadius(3)
            .foregroundStyle(by: .value("Macro", macroValue.macro))
        }
        .chartForegroundStyleScale(Macro.chartStyleScale(colorScheme))
        .chartLegend(.hidden)
        .frame(width: 28, height: 28)
    }
    
    var emojiText: some View {
        Text(emoji)
    }
    
    var nameTexts: some View {
        var view = Text(name)
            .font(.body)
            .fontWeight(.medium)
            .foregroundStyle(Color(.label))
        if let detail = detail, !detail.isEmpty {
            view = view
            + Text(", ")
            
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(Color(.secondaryLabel))
            + Text(detail)
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(Color(.secondaryLabel))
        }
        if let brand = brand, !brand.isEmpty {
            view = view
//            + Text(detail?.isEmpty == true ? "" : ", ")
            + Text(", ")
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(Color(.tertiaryLabel))
            + Text(brand)
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(Color(.tertiaryLabel))
        }
        view = view

        .font(.callout)
        .fontWeight(.semibold)
        .foregroundStyle(Color(.secondaryLabel))
        
        return view
            .alignmentGuide(.listRowSeparatorLeading) { dimensions in
                dimensions[.leading]
            }
    }
}
