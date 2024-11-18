//
//  AvailabilityView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct AvailabilityView: View {
    let availability: SeasonalData
    
    func textColorForAvailabilityType(_ type: Availability) -> Color {
        switch type {
        case .regionally:
            return .green
        case .inStock:
            return .yellow
        case .notRegionally:
            return .red
        }
    }
    
    func backgroundColorForAvailabilityType(_ type: Availability) -> Color {
        textColorForAvailabilityType(type).opacity(0.2)
    }
    
    func symbolForAvailabilityType(_ type: Availability) -> String {
        switch type {
        case .regionally:
            return "leaf.fill"
        case .inStock:
            return "shippingbox.fill"
        case .notRegionally:
            return "ferry.fill"
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: symbolForAvailabilityType(availability.availability))
                    .foregroundColor(textColorForAvailabilityType(availability.availability))
                
                Text(availability.availability.rawValue)
                    .font(.subheadline)
                    .foregroundColor(textColorForAvailabilityType(availability.availability))
            }
            .padding(6)
            .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColorForAvailabilityType(availability.availability))
            )
        }
    }
}
    
