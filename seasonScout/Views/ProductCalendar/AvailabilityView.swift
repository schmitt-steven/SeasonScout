//
//  AvailabilityView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct AvailabilityView: View {
    let availability: SeasonalData
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: symbolForAvailabilityType(availability.availability))
                    .foregroundColor(textColorForAvailabilityType(availability.availability))
                
                Text(availability.availability.rawValue)
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
    
