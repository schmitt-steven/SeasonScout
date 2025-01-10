//
//  SwipeDirection.swift
//  SeasonScout
//
//  Created by Poimandres on 21.12.24.
//

import SwiftUI

// Enum to define the swipe direction for month switching
enum SwipeDirection {
    case next
    case previous
}

// Service class to handle the logic of switching months
class MonthSwitcherService {
    
    // Changes the selected month based on the swipe direction
    static func changeMonth(selectedMonth: Binding<Month>, direction: SwipeDirection) {
        let months = Month.allCases // Get all months as an array
        guard let currentIndex = months.firstIndex(of: selectedMonth.wrappedValue) else { return } // Find the current month's index
        
        var newIndex = currentIndex
        if direction == .next {
            newIndex = (currentIndex + 1) % months.count // Move to the next month (wrap around if necessary)
        } else if direction == .previous {
            newIndex = (currentIndex - 1 + months.count) % months.count // Move to the previous month (wrap around if necessary)
        }
        
        // Update the selected month with an animation
        withAnimation(.easeInOut(duration: 1)) {
            selectedMonth.wrappedValue = months[newIndex]
        }
    }
}
