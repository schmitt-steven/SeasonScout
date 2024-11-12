import SwiftUI
import Charts

struct RecipePieChart: View {
    
    let seasonalData: [RecipeSeasonalMonthData]
    @State var selectedChartSectionValue: Int?
    @State var selectedMonth: MonthChartData?

    let chartAngle: Double = 30.0 // Defines the size/angle range of each chart section

    // Computes real world month formatted in German
    var currentIRLMonth: Month? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "LLLL"
        return Month(rawValue: dateFormatter.string(from: Date()))
    }

    // Convert RecipeSeasonalMonthData to MonthChartData
    func monthChartData(for monthData: RecipeSeasonalMonthData) -> MonthChartData {
        return MonthChartData(
            month: monthData.month,
            value: chartAngle,
            seasonality: monthData.availability
        )
    }

    // Values of each chart section are added up to calculate the selected month
    func calculateSelectedMonth(chartSectionValue: Double) {
        var cumulativeTotal = 0.0
        
        _ = seasonalData.first { monthData in
            cumulativeTotal += chartAngle
            if cumulativeTotal >= chartSectionValue {
                selectedMonth = monthChartData(for: monthData)
                return true
            }
            return false
        }
    }

    var body: some View {
        Chart(Array(seasonalData.enumerated()), id: \.element.month) { index, monthData in
            let chartData = monthChartData(for: monthData)

            SectorMark(
                angle: .value("Saisonale Daten", chartData.value),
                innerRadius: .ratio(0.7),
                outerRadius: monthData.month.rawValue == selectedMonth?.month.rawValue ? .ratio(1) : .ratio(0.9),
                angularInset: 2
            )
            // Show month abbreviation over each chart section
            .annotation(position: .overlay) {
                Text(chartData.month.rawValue.prefix(3))
                    .bold()
                    .font(.caption2)
                    .opacity(0.5)
            }
            .opacity(chartData.month.rawValue == selectedMonth?.month.rawValue ? 1 : 0.7)
            .foregroundStyle(chartData.color)
            .cornerRadius(3)
        }
        .frame(height: 350)
        .shadow(radius: 3)
        .chartAngleSelection(value: $selectedChartSectionValue)  // stores the section value in the variable once the user clicked on any part of the chart
        
        // sets default month to IRL month
        .onAppear {
            if let currentIRLMonth = currentIRLMonth {
                selectedMonth = monthChartData(for: seasonalData.first { $0.month == currentIRLMonth } ?? RecipeSeasonalMonthData(month: currentIRLMonth, availability: "nein"))
            }
        }
        
        // change selected month based on selected chart section
        .onChange(of: selectedChartSectionValue) { oldValue, newValue in
            withAnimation {
                if let newValue {
                    calculateSelectedMonth(chartSectionValue: Double(newValue))
                }
            }
        }
        
        // show month and related seasonality inside the pie chart
        .chartBackground { _ in
            VStack {
                if let selectedMonth {
                    Text("\(selectedMonth.month.rawValue)")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .fontWeight(.regular).foregroundStyle(.secondary)
                        .shadow(radius: 5)
                        .padding(.bottom, 3)
                    Text(selectedMonth.seasonalityStatusText)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    RecipePieChart(seasonalData: Recipe.recipes[1].seasonalData)
}
