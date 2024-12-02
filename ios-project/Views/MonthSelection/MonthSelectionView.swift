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
                            Text(month.rawValue.prefix(3))
                                .font(.headline)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(month == selectedMonth ? .orange : .white))
                                .containerRelativeFrame(
                                    .horizontal,
                                    count: verticalSizeClass == .regular ? 4 : 8,
                                    spacing: 16
                                )
                                .onTapGesture {
                                    withAnimation {
                                        selectedMonth = month
                                    }
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
