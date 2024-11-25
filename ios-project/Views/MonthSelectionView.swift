//
//  MonthScrollView.swift
//  ios-project
//
//  Created by Henry Harder on 19.11.24.
//

import SwiftUI

struct MonthSelectionView: View {
    @Binding var selectedMonth: Month
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Month.allCases, id: \.self) { month in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .containerRelativeFrame(
                                    .horizontal,
                                    count: verticalSizeClass == .regular ? 3 : 6,
                                    spacing: 16
                                )
                                .foregroundStyle(month == selectedMonth ? .orange : .white)
                                .onTapGesture {
                                    withAnimation {
                                        selectedMonth = month
                                    }
                                }
                            VStack {
                                Text(month.rawValue)
                                    .foregroundColor(.black)
                                    .font(.headline)
                            }
                        }
                        .frame(height: 30)
                        .id(month)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .onAppear {
                // Automatisches Scrollen zum ausgewählten Monat
                scrollProxy.scrollTo(selectedMonth, anchor: .center)
            }
        }
    }
}
