//
//  ProductRowView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    @Binding var selectedMonth: Month

    var body: some View {
        NavigationLink(
            destination: ProductInfoView(
                product: product, selectedMonth: selectedMonth)
        ) {
            GroupBox {
                VStack {
                    HStack {
                        if product.imageName.isEmpty {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.secondary)
                        } else {
                            Image(uiImage: UIImage(named: product.imageName)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(8)
                                .foregroundStyle(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.name)
                                .font(.headline.bold())

                            Text(product.botanicalName)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 5)

                            if let seasonalData = seasonalDataForSelectedMonth()
                            {
                                AvailabilityView(availability: seasonalData)
                            } else {
                                Text(
                                    "Nicht verfügbar im \(selectedMonth.rawValue)"
                                )
                                .font(.subheadline)
                                .foregroundColor(
                                    Color(UIColor.systemGroupedBackground))
                            }
                        }
                        Spacer()
                    }
                }
            }
                // Detect swiping gesture
                .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local).onEnded { value in
                    
                    // Only change month on horizontal swipe, not(!) a vertical one
                    if abs(value.translation.width) > abs(value.translation.height) {
                        if value.translation.width < 0 {
                            MonthSwitcherService.changeMonth(selectedMonth: $selectedMonth, direction: .next)
                        } else {
                            MonthSwitcherService.changeMonth(selectedMonth: $selectedMonth, direction: .previous)
                        }
                    }
                    
                })
        }
        .buttonStyle(PlainButtonStyle())
    }

    // Funktion zur Prüfung der Verfügbarkeit des Produkts im aktuellen Monat
    private func seasonalDataForSelectedMonth() -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
