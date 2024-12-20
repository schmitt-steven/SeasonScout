//
//  MonthScrollView.swift
//  ios-project
//
//  Created by Henry Harder on 19.11.24.
//

//
//  MonthScrollView.swift
//  ios-project
//
//  Created by Henry Harder on 19.11.24.
//

import SwiftUI

struct MonthView: View {
    let month: Month
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(month.rawValue.prefix(3))
            .font(.headline)
            .padding(.horizontal, 18)
            .padding(.vertical, 6)
            .background(MeshGradient(
                width: 3, height: 3,
                points: [
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1),
                ],
                colors: isSelected
                    ? [
                        .red, .red, .orange,
                        .orange, .red, .orange,
                        .yellow, .orange, .yellow,
                    ]
                    : [
                        .clear, .clear, .clear,
                        .clear, .clear, .clear,
                        .clear, .clear, .clear,
                    ])
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture(perform: onTap)
            .id(month)
    }
}

struct MonthSelectionView: View {
    @Binding var selectedMonth: Month

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                MonthListView(selectedMonth: $selectedMonth)
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

struct MonthListView: View {
    @Binding var selectedMonth: Month

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Month.allCases, id: \.self) { month in
                MonthView(
                    month: month,
                    isSelected: month == selectedMonth,
                    onTap: {
                        withAnimation(.smooth) {
                            selectedMonth = month
                        }
                    }
                )
            }
        }
    }
}
