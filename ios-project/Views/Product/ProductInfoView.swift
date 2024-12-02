//
//  ProductInfoView.swift
//  ios-project
//
//  Created by Henry Harder on 23.11.24.
//

import SwiftUI

struct ProductInfoView: View {
    @ObservedObject var product: Product
    let selectedMonth: Month
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    internal init(product: Product, selectedMonth: Month) {
        self.product = product
        self.selectedMonth = selectedMonth
        hapticFeedback.prepare()
    }

    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .frame(width: 150, height: 150)
                    
                    Text(product.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(product.botanicalName)
                        .font(.title2)
                        .foregroundColor(.gray)

                    Text("Kurzbeschreibung")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.top, 25)
                    GroupBox {
                        VStack(alignment: .leading) {
                            Text(ProductDescriptions.productDescriptions[product.name] ?? "Keine Kurzbeschreibung vorhanden")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)

                    Text("Verfügbarkeit")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.top, 25)
                    AvailabilityMonthView(product: product, selectedMonth: selectedMonth)

                    Text("Ähnliche Produkte")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.top, 25)
                    SimilarProductsView(
                        product: product, selectedMonth: selectedMonth)
                    .frame(maxWidth: .infinity)
                    
                    Text("Passende Rezepte")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.top, 25)
                    MatchingRecipesView(
                        product: product, selectedMonth: selectedMonth
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hapticFeedback.impactOccurred()
                        hapticFeedback.prepare()
                    }) {
                        ProductHeartView(product: product)
                    }
                }
            }
        }
    }

    private func seasonalDataForSelectedMonth() -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == selectedMonth })
    }

    private func seasonalDataForMonth(_ month: Month) -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == month })
    }
}

#Preview {
    ProductInfoView(product: Product.products[2], selectedMonth: .apr)
}
