//
//  AvailabilityFunc.swift
//  ios-project
//
//  Created by Henry Harder on 23.11.24.
//

import SwiftUI

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
