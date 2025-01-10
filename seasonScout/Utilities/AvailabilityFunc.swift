//
//  AvailabilityFunc.swift
//  ios-project
//
//  Created by Henry Harder on 23.11.24.
//

import SwiftUI

// Returns a text color based on the availability type
func textColorForAvailabilityType(_ type: Availability) -> Color {
    switch type {
    case .regionally:
        return .green // Green indicates regional availability
    case .inStock:
        return .yellow // Yellow indicates the item is in stock
    case .notRegionally:
        return .red // Red indicates not regionally available
    }
}

// Returns a background color based on the availability type with lower opacity
func backgroundColorForAvailabilityType(_ type: Availability) -> Color {
    textColorForAvailabilityType(type).opacity(0.2)
}

// Returns a symbol name string based on the availability type
func symbolForAvailabilityType(_ type: Availability) -> String {
    switch type {
    case .regionally:
        return "leaf.fill" // Leaf symbol for regional availability
    case .inStock:
        return "shippingbox.fill" // Box symbol for items in stock
    case .notRegionally:
        return "ferry.fill" // Ferry symbol for not regionally available
    }
}
