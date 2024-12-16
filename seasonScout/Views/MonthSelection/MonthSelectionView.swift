//
//  MonthScrollView.swift
//  ios-project
//
//  Created by Henry Harder on 19.11.24.
//

import SwiftUI

struct MonthSelectionView: View {
    @Binding var selectedMonth: Month
        
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(Month.allCases, id: \.self) { month in
                            Text(month.rawValue.prefix(3))
                                .font(.headline)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(month == selectedMonth ? .orange : .clear))
                                .onTapGesture {
                                    withAnimation(.smooth) {
                                        selectedMonth = month
                                    }
                                }
                        .id(month)
                    }
                }
                .scrollTargetLayout()
            }
            .padding(.horizontal, 16)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .onAppear {
                // Automatisches Scrollen zum ausgewählten Monat
                scrollProxy.scrollTo(selectedMonth, anchor: .center)
            }
        }
    }
}
