//
//  DateFormatter.swift
//  ios-project
//

import Foundation

extension DateFormatter {
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}

extension Date {
    var currentMonth: Month? {
        let monthString = DateFormatter.monthFormatter.string(from: self)
        return Month.allCases.first { $0.rawValue == monthString }
    }
}

