//
//  RecipeSeasonalityStatusView.swift
//  ios-project
//

import SwiftUI

struct RecipeSeasonalityStatusView: View {
    let seasonalData: [RecipeSeasonalMonthData]
    let selectedMonth: Month
    
    let isSeasonalText = "Derzeit zum Großteil mit regionalen Produkten zubereitbar!"
    let isPartiallySeasonalText = "Derzeit teilweise mit regionalen Produkten zubereitbar."
    let isNotSeasonalText = "Derzeit nicht mit regionalen Produkten zubereitbar."

    var body: some View {
        if let monthStatus = seasonalData.first(where: { $0.month == selectedMonth }) {
            HStack(alignment: .top) {
                statusIcon(for: monthStatus)
                    .foregroundStyle(statusColor(for: monthStatus))
                    .padding(10)
                    .background(
                        Circle()
                            .fill(statusColor(for: monthStatus).opacity(0.2))
                    )
                
                Text(statusText(for: monthStatus))
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
    }

    func statusIcon(for status: RecipeSeasonalMonthData) -> Image {
        switch status.availability {
        case "ja":
            return Image(systemName: "calendar.badge.checkmark")
        case "(ja)":
            return Image(systemName: "calendar.badge.checkmark")
        default:
            return Image(systemName: "calendar.badge.exclamationmark")
        }
    }

    func statusColor(for status: RecipeSeasonalMonthData) -> Color {
        switch status.availability {
        case "ja":
            return .green
        case "(ja)":
            return .yellow
        default:
            return .red
        }
    }
    
    func statusText(for status: RecipeSeasonalMonthData) -> String {
        switch status.availability {
        case "ja":
            return isSeasonalText
        case "(ja)":
            return isPartiallySeasonalText
        default:
            return isNotSeasonalText
        }
    }
}
