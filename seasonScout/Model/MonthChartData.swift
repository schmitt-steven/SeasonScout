//
//  MonthChartData.swift
//  ios-project
//
//  Created by Poimandres on 10.11.24.
//

import SwiftUI

// Data structure used to build the seasonal data pie chart for recipes
struct MonthChartData {
    let month: Month
    let value: Double
    let seasonality: String
    
    var color: Color {
        switch seasonality {
        case "ja": .green
        case "(ja)": .yellow
        default: .red
        }
    }
    var seasonalityStatusText: String {
        switch seasonality {
        case "ja": "Die meisten Zutaten\nsind regional erhältlich!"
        case "(ja)": "Die Zutaten sind teilweise\nregional erhältlich."
        default: "Die Zutaten sind nur\nimportiert erhältlich."
        }
    }
}
