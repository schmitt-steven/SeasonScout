import SwiftUI

struct RecipeSeasonalityStatus: View {
    let seasonalData: [Month: String]
    
    // Computes current month formatted in German
    var currentMonth: Month? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "LLLL"
        return Month(rawValue: dateFormatter.string(from: Date()))
    }
    
    let isSeasonalText = "Derzeit zum Großteil mit regionalen Produkten zubereitbar!"
    let isPartiallySeasonalText = "Derzeit teilweise mit regionalen Produkten zubereitbar."
    let isNotSeasonalText = "Derzeit nicht mit regionalen Produkten zubereitbar."

    var body: some View {
        
        Group {
            HStack {
                if let monthStatus = seasonalData[currentMonth!] {
                    
                    statusIcon(for: monthStatus)
                        .foregroundStyle(statusColor(for: monthStatus))
                        .font(.title)
                        .padding(.top, 3)
                    
                    Text(statusText(for: monthStatus))
                        .font(.subheadline)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                }
            }.padding(10)
            
        }.background(.lighterGray)
            .clipShape(.rect(cornerRadius: 15))
            .shadow(color: .gray, radius: 2)
            .padding(.horizontal, 20)
    }

    func statusIcon(for status: String) -> Image {
        switch status {
        case "ja":
            return Image(systemName: "calendar.badge.checkmark")
        case "(ja)":
            return Image(systemName: "calendar.badge.checkmark")
        default:
            return Image(systemName: "calendar.badge.exclamationmark")
        }
    }

    func statusColor(for status: String) -> Color {
        switch status {
        case "ja":
            return .green
        case "(ja)":
            return .orange
        default:
            return .red
        }
    }
    
    func statusText(for status: String) -> String {
        switch status {
        case "ja":
            return isSeasonalText
        case "(ja)":
            return isPartiallySeasonalText
        default:
            return isNotSeasonalText
        }
    }
}
