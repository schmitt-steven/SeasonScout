//
//  SimilarProductsView.swift
//  ios-project
//
//  Created by Henry Harder on 21.11.24.
//

import SwiftUI

struct SimilarProductsView: View {
    let product: Product
    let selectedMonth: Month
    let productsOfSameSubtype: [Product]
    
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(product: Product, selectedMonth: Month) {
        self.product = product
        self.selectedMonth = selectedMonth
        self.productsOfSameSubtype = Product.products.filter { otherProduct in
            // Prüfen, ob Subtyp gleich und ID unterschiedlich ist
            otherProduct.subtype == product.subtype
                && otherProduct.id != product.id
        }
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if productsOfSameSubtype.isEmpty {
                    // Anzeige einer Nachricht bei leerer Rezeptliste
                    GroupBox {
                        Text("Keine Produkte gefunden.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    ForEach(productsOfSameSubtype) { product in
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
                        .containerRelativeFrame(
                            .horizontal,
                            count: verticalSizeClass == .regular
                                ? 1 : 4,
                            spacing: 16
                        )
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollClipDisabled()
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
    
    // Funktion zur Prüfung der Verfügbarkeit des Produkts im aktuellen Monat
    private func seasonalDataForSelectedMonth() -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
