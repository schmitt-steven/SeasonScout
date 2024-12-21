//
//  SwipeDirection.swift
//  SeasonScout
//
//  Created by Poimandres on 21.12.24.
//
import SwiftUI


enum SwipeDirection {
    case next
    case previous
}

class MonthSwitcherService {
    
    static func changeMonth(selectedMonth: Binding<Month>, direction: SwipeDirection) {
        let months = Month.allCases
        guard let currentIndex = months.firstIndex(of: selectedMonth.wrappedValue) else { return }
        
        var newIndex = currentIndex
        if direction == .next {
            newIndex = (currentIndex + 1) % months.count
        } else if direction == .previous {
            newIndex = (currentIndex - 1 + months.count) % months.count
        }
        
        withAnimation(.easeInOut(duration: 1)) {
            selectedMonth.wrappedValue = months[newIndex]
        }
    }
    
}
