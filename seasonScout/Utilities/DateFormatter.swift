//
//  DateFormatter.swift
//  ios-project
//

import Foundation

// Extension for `DateFormatter` to create a custom month formatter
extension DateFormatter {
    // A static property for formatting a date to a month name
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // Format to display the full month name (e.g., January)
        return formatter
    }()
}

extension Date {
    // Computed property to return the current month as a `Month` enum
    var currentMonth: Month? {
        // Format the current date to get the month name
        let monthString = DateFormatter.monthFormatter.string(from: self)
        // Match the month name with the `Month` enum
        return Month.allCases.first { $0.rawValue == monthString }
    }
}

