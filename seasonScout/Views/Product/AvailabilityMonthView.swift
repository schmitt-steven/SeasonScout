//
//  AvailabilityMonthView.swift
//  ios-project
//
//  Created by Henry Harder on 23.11.24.
//

import SwiftUI

struct AvailabilityMonthView: View {
    let product: Product
    let selectedMonth: Month

//    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                HStack(spacing: 32) {
                    ForEach(Month.allCases, id: \.self) { month in
                        let availability = seasonalDataForMonth(month)?
                            .availability
                        GroupBox {
                            VStack {
                                Text(month.rawValue)
                                    .font(.title.bold())
                                    .padding(.bottom, 5)
                                HStack {
                                    HStack {
                                        Image(
                                            systemName:
                                                symbolForAvailabilityType(
                                                    availability!)
                                        )
                                        .foregroundStyle(
                                            availability != nil
                                                ? textColorForAvailabilityType(
                                                    availability!)
                                                : Color.black)
                                    }
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(
                                                backgroundColorForAvailabilityType(
                                                    availability!))
                                    )
                                    Text(
                                        availability?.rawValue
                                            ?? "Nicht identifizierbar"
                                    )
                                    .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .containerRelativeFrame(
                            .horizontal
                        )
                        .scrollTransition { content, phase in
                            return content
                                .opacity(phase.value == 0 ? 1 : 0.5)
                                .offset(x: phase.value * -20)
                        }
                        .id(month)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .onAppear {
                // Automatisches Scrollen zum ausgewählten Monat
                scrollProxy.scrollTo(selectedMonth, anchor: .center)
            }
        }
    }

    private func seasonalDataForMonth(_ month: Month) -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == month })
    }
}

#Preview {
    AvailabilityMonthView(product: Product.products[2], selectedMonth: .nov)
}
