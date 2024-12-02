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

    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Month.allCases, id: \.self) { month in
                        let availability = seasonalDataForMonth(month)?
                            .availability
                        GroupBox {
                            VStack {
                                Text(month.rawValue)
                                    .foregroundColor(.black)
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
                                    .foregroundStyle(.black)
                                    .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .containerRelativeFrame(
                            .horizontal,
                            count: verticalSizeClass == .regular ? 1 : 4,
                            spacing: 16
                        )
                        .foregroundStyle(Color(UIColor.systemGroupedBackground))
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.0)
                                .scaleEffect(
                                    x: phase.isIdentity ? 1.0 : 0.9,
                                    y: phase.isIdentity ? 1.0 : 0.9
                                )
                                .offset(y: phase.isIdentity ? 0 : 50)
                        }
                        .id(month)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(1, for: .scrollContent)
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
