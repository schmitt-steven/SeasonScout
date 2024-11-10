//
//  RecipePieChart.swift
//  ios-project
//
//  Created by Poimandres on 09.11.24.
//

import SwiftUI
import Charts

struct RecipePieChart: View {
    
    let seasonalData: [(Month, String)]
    @State var selectedChartSection: Int?
    @State var selectedMonth: MonthChartData?

    // Convert seasonalData to MonthChartData with plottable a value
    var plottableSeasonalData: [MonthChartData] {
        let chartAngle = 30.0
        return seasonalData.map { (month, seasonality) in
            MonthChartData(month: month, value: chartAngle, seasonality: seasonality)
        }
    }
    
    // Computes real world month formatted in German
    var currentIRLMonth: Month? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "LLLL"
        return Month(rawValue: dateFormatter.string(from: Date()))
    }
    
    func calculateSelectedMonth(chartSectionValue: Double) {
        var cumulativeTotal = 0.0
        
        _ = plottableSeasonalData.first { monthChartData in
            cumulativeTotal += monthChartData.value
            if cumulativeTotal >= chartSectionValue {
                selectedMonth = monthChartData
                return true
            }
            return false
        }
    }
    
    var body: some View {
            
        Chart(Array(plottableSeasonalData.enumerated()), id: \.element.month) { index, monthChartData in                SectorMark(
                    angle: .value("Saisonale Daten", monthChartData.value),
                    innerRadius: .ratio(0.7),
                    outerRadius:
                        monthChartData.month.rawValue == selectedMonth?.month.rawValue ? .ratio(1) : .ratio(0.9),
                    angularInset: 2
                )
                .annotation(position: .overlay) {
                    Text(monthChartData.month.rawValue.prefix(3))
                        .bold()
                        .font(.caption2)
                        .opacity(0.7)
                }
                .opacity(monthChartData.month.rawValue == selectedMonth?.month.rawValue ? 1 : 0.7)
                .foregroundStyle(monthChartData.color)
                .cornerRadius(3)
            }
            .frame(height: 350)
            .shadow(radius: 3)
            .chartAngleSelection(value: $selectedChartSection)
        
            .onAppear {
                       if let currentIRLMonth = currentIRLMonth {
                           selectedMonth = plottableSeasonalData.first { $0.month == currentIRLMonth }
                       }
                   }
        
            .onChange(of: selectedChartSection) { oldValue, newValue in
                withAnimation {
                    if let newValue {
                        calculateSelectedMonth(chartSectionValue: Double(newValue))
                    }
                }
            }
        
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
    let rec = Recipe.recipes[5]
    RecipePieChart(seasonalData: rec.sortedSeasonalData)
}
