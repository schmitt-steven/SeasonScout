//
//  TestRecipePieChart.swift
//  ios-project
//

import SwiftUI
import Charts

struct TestRecipePieChart: View {
    
    let seasonalData: [RecipeSeasonalMonthData]
    var selectedMonth: Month
    @State var selectedChartSectionValue: Int?
    @State var selectedMonthPieChart: MonthChartData?

    let chartAngle: Double = 30.0

    func monthChartData(for monthData: RecipeSeasonalMonthData) -> MonthChartData {
        return MonthChartData(
            month: monthData.month,
            value: chartAngle,
            seasonality: monthData.availability
        )
    }

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
        Chart(Array(seasonalData.enumerated()), id: \.element.month) { index, monthData in
            let chartData = monthChartData(for: monthData)

            SectorMark(
                angle: .value("Saisonale Daten", chartData.value),
                innerRadius: .ratio(0.7),
                outerRadius: monthData.month.rawValue == selectedMonthPieChart?.month.rawValue ? .ratio(1) : .ratio(0.9),
                angularInset: 2
            )
            .annotation(position: .overlay) {
                Text(chartData.month.rawValue.prefix(3))
                    .font(.caption2)
                    .bold()
            }
            .opacity(chartData.month.rawValue == selectedMonthPieChart?.month.rawValue ? 1 : 0.2)
            .foregroundStyle(chartData.color)
            .cornerRadius(3)
        }
        .frame(height: 350)
        .chartAngleSelection(value: $selectedChartSectionValue)
        .onAppear {
            selectedMonthPieChart = monthChartData(for: seasonalData.first { $0.month == selectedMonth } ?? RecipeSeasonalMonthData(month: selectedMonth, availability: "nein"))
        }
        .onChange(of: selectedChartSectionValue) { oldValue, newValue in
            withAnimation {
                if let newValue {
                    calculateSelectedMonth(chartSectionValue: Double(newValue))
                }
            }
        }
        .chartBackground { _ in
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
