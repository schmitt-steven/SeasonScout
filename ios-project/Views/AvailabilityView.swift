//
//  AvailabilityView.swift
//  ios-project
//

import SwiftUI

struct AvailabilityView: View {
    let availability: MonthAvailability

    func textColorForAvailabilityType(_ type: AvailabilityType) -> Color {
        switch type {
        case .Regional:
            return .green
        case .Lagerverfügbarkeit:
            return .yellow
        case .Import:
            return .red
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(textColorForAvailabilityType(availability.availabilityType))
                .frame(width: 10, height: 10)
            Text(availability.availabilityType.rawValue)
                .font(.subheadline)
                .foregroundColor(textColorForAvailabilityType(availability.availabilityType))
                .padding(4)
        }
    }
}
