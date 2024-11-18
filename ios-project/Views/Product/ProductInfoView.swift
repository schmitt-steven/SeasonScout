//
//  ProductInfoView.swift
//  ios-project
//
//  Created by Henry Harder on 15.11.24.
//

import SwiftUI

struct ProductInfoView: View {
    let product: Product
    let selectedMonth: Month

    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Spacer()

                // Titel (Produktname)
                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                // Verfügbarkeit im selectedMonth anzeigen
                if let seasonalData = seasonalDataForSelectedMonth() {
                    AvailabilityView(availability: seasonalData)
                        .padding(.top, 10)
                } else {
                    Text("Nicht verfügbar im \(selectedMonth.rawValue)")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }

                Text("Produktart: \(product.type.rawValue)")
                    .font(.title2)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func seasonalDataForSelectedMonth() -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
