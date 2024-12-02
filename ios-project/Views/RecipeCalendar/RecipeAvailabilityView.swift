//
//  RecipeAvailabilityView.swift
//  ios-project
//
//  Created by Henry Harder on 16.11.24.
//

import SwiftUI

struct RecipeAvailabilityView: View {
    let availability: RecipeSeasonalMonthData

    func textColorForAvailabilityType(_ type: String) -> Color {
        switch type {
        case "ja":
            return .green
        case "(ja)":
            return .yellow
        case "nein":
            return .red
        default:
            return .blue
        }
    }

    func backgroundColorForAvailabilityType(_ type: String) -> Color {
        textColorForAvailabilityType(type).opacity(0.2)
    }

    func symbolForAvailabilityType(_ type: String) -> String {
        switch type {
        case "ja":
            return "leaf.fill"
        case "(ja)":
            return "exclamationmark.circle.fill"
        case "nein":
            return "ferry.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    func textForAvailabilityType(_ type: String) -> String {
        switch type {
        case "ja":
            return "regional verfügbar"
        case "(ja)":
            return "teilweise regional verfügbar"
        case "nein":
            return "nicht regional verfügbar"
        default:
            return "nicht identifizierbar"
        }
    }

    var body: some View {
        HStack {
            HStack {
                Image(systemName: symbolForAvailabilityType(availability.availability))
                    .foregroundColor(textColorForAvailabilityType(availability.availability))
                
                Text(textForAvailabilityType(availability.availability))
                    .font(.subheadline)
                    .foregroundColor(textColorForAvailabilityType(availability.availability))
            }
            .padding(.top, 6)
            .padding(.bottom, 6)
            .padding(.leading, 18)
            .padding(.trailing, 18)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColorForAvailabilityType(availability.availability))
            )
        }
    }
}
