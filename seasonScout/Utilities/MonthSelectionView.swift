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
    @State var gradientOpacity: Double
    
    init(month: Month, isSelected: Bool, onTap: @escaping () -> Void) {
        self.month = month
        self.isSelected = isSelected
        self.onTap = onTap
        self.gradientOpacity = isSelected ? 1.0 : 0.0
    }
    
    var body: some View {
        Text(month.rawValue.prefix(3))
            .font(.headline)
            .padding(.horizontal, 18)
            .padding(.vertical, 6)
            .background(
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        .init(0, 0), .init(0.5, 0), .init(1, 0),
                        .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                        .init(0, 1), .init(0.5, 1), .init(1, 1),
                    ],
                    colors: [
                        .red.opacity(gradientOpacity), .red.opacity(gradientOpacity), .orange.opacity(gradientOpacity),
                        .orange.opacity(gradientOpacity), .red.opacity(gradientOpacity), .orange.opacity(gradientOpacity),
                        .yellow.opacity(gradientOpacity), .orange.opacity(gradientOpacity), .yellow.opacity(gradientOpacity),
                    ])
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture(perform: onTap)
            .onChange(of: isSelected) {
                Task {
                    await animateGradientOpacity(to: isSelected ? 1.0 : 0.0, duration: 0.6)
                }
            }
            .id(month)
    }
        
    private func animateGradientOpacity(to targetOpacity: Double, duration: TimeInterval) async {
        let steps = 60 // Frames per second
        let interval = duration / Double(steps)
        let delta = (targetOpacity - gradientOpacity) / Double(steps)
        
        for _ in 0..<steps {
            gradientOpacity += delta
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
        }
        
        gradientOpacity = targetOpacity
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
            .onChange(of: selectedMonth) {
                withAnimation(.smooth(duration: 1)) {
                    scrollProxy.scrollTo(selectedMonth, anchor: .center)
                }
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
                        withAnimation(.smooth(duration: 1)) {
                            selectedMonth = month
                        }
                    }
                )
            }
        }
    }
}
