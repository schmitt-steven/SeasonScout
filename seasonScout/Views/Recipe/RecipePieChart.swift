import Charts
import SwiftUI

/// A view that displays a pie chart showing the seasonality of ingredients based on the provided seasonal data.
struct RecipePieChart: View {
    let seasonalData: [RecipeSeasonalMonthData]  // Seasonal data for the months
    var selectedMonth: Month  // The currently selected month to highlight
    @State var selectedChartSectionValue: Int?  // Tracks the selected chart section
    @State var selectedMonthPieChart: MonthChartData?  // The selected month's chart data

    let chartAngle: Double = 30.0  // Angle for each month's sector (adjust for larger/smaller slices)

    // Converts seasonal data to chart data
    func monthChartData(for monthData: RecipeSeasonalMonthData)
        -> MonthChartData
    {
        return MonthChartData(
            month: monthData.month,
            value: chartAngle,
            seasonality: monthData.availability
        )
    }

    // Calculates the selected month based on the chart section value
    func calculateSelectedMonth(chartSectionValue: Double) {
        var cumulativeTotal = 0.0

        _ = seasonalData.first { monthData in
            cumulativeTotal += chartAngle
            if cumulativeTotal >= chartSectionValue {
                selectedMonthPieChart = monthChartData(for: monthData)
                return true
            }
            return false
        }
    }

    var body: some View {
        // Pie chart rendering
        Chart(Array(seasonalData.enumerated()), id: \.element.month) {
            index, monthData in
            let chartData = monthChartData(for: monthData)

            SectorMark(
                angle: .value("Saisonale Daten", chartData.value),
                innerRadius: .ratio(0.7),
                outerRadius: monthData.month.rawValue
                    == selectedMonthPieChart?.month.rawValue
                    ? .ratio(1) : .ratio(0.9),
                angularInset: 2
            )
            .annotation(position: .overlay) {
                Text(chartData.month.rawValue.prefix(3))  // Shows the first 3 characters of the month's name
                    .font(.caption2)
                    .bold()
            }
            .opacity(
                chartData.month.rawValue
                    == selectedMonthPieChart?.month.rawValue ? 1 : 0.2
            )
            .foregroundStyle(chartData.color)
            .cornerRadius(3)
        }
        .frame(height: 350)
        .chartAngleSelection(value: $selectedChartSectionValue)
        .onAppear {
            // Set the initial selected month on appearance
            selectedMonthPieChart = monthChartData(
                for: seasonalData.first { $0.month == selectedMonth }
                    ?? RecipeSeasonalMonthData(
                        month: selectedMonth, availability: "nein"))
        }
        .onChange(of: selectedChartSectionValue) { oldValue, newValue in
            // When the selected section changes, update the selected month
            withAnimation {
                if let newValue {
                    calculateSelectedMonth(chartSectionValue: Double(newValue))
                }
            }
        }
        .chartBackground { _ in
            // Show additional info on the chart background when a month is selected
            VStack {
                if let selectedMonthPieChart {
                    Text("\(selectedMonthPieChart.month.rawValue)")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .fontWeight(.medium).foregroundStyle(.secondary)
                        .padding(.bottom, 3)
                    Text(selectedMonthPieChart.seasonalityStatusText)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .opacity(0.9)
                }
            }
        }
    }
}
