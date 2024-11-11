//
//  MonthAvailability.swift
//  ios-project
//

import SwiftUI

struct MonthAvailability: Identifiable {
    var id = UUID()
    var month: String
    var availabilityType: AvailabilityType
}
