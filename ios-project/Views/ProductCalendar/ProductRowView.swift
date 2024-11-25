//
//  ProductRowView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    let selectedMonth: Month

    var body: some View {
        NavigationLink(destination: ProductInfoView2(product: product, selectedMonth: selectedMonth)) {
            GroupBox {
                VStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.secondary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.name)
                                .font(.headline.bold())
                            
                            Text(product.botanicalName)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 5)
                            
                            if let seasonalData = seasonalDataForSelectedMonth() {
                                AvailabilityView(availability: seasonalData)
                            } else {
                                Text("Nicht verfügbar im \(selectedMonth.rawValue)")
                                    .font(.subheadline)
                                    .foregroundColor(Color(UIColor.systemGroupedBackground))
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    // Funktion zur Prüfung der Verfügbarkeit des Produkts im aktuellen Monat
    private func seasonalDataForSelectedMonth() -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
