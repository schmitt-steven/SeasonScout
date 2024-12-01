//
//  ProductInfoView2.swift
//  ios-project
//
//  Created by Henry Harder on 23.11.24.
//

import SwiftUI

struct ProductInfoView2: View {
    @ObservedObject var product: Product
    let selectedMonth: Month
    let productDescriptions = ProductDescriptions()
    
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    internal init(product: Product, selectedMonth: Month) {
        self.product = product
        self.selectedMonth = selectedMonth
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
                    }
                    .frame(maxWidth: .infinity)

                    Text("Verfügbarkeit")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.top, 25)
                    AvailabilityMonthView(product: product, selectedMonth: selectedMonth)

                    HStack {
                        NavigationLink(
                            destination: SimilarRecipesView(
                                product: product, selectedMonth: selectedMonth)
                        ) {
                            GroupBox {
                                HStack {
                                    Text("Passende Rezepte")
                                        .font(.headline.bold())
                                        .foregroundColor(isDarkModeEnabled ? .white : .black)

                                    Spacer()
                                    Image(
                                        systemName: "arrow.up.right.square.fill"
                                    )
                                    .foregroundColor(.orange)
                                }
                                .padding()
                            }
                        }

                        NavigationLink(
                            destination: SimilarProductsView(
                                product: product, selectedMonth: selectedMonth)
                        ) {
                            GroupBox {
                                HStack {
                                    Text("Ähnliche Produkte")
                                        .font(.headline.bold())
                                        .foregroundColor(isDarkModeEnabled ? .white : .black)

                                    Spacer()
                                    Image(
                                        systemName: "arrow.up.right.square.fill"
                                    )
                                    .foregroundColor(.orange)
                                }
                                .padding()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 25)
                }
                .padding()
            }
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        product.isFavorite.toggle()
                        product.setProductFavorite(for: product.id, isFavorite: product.isFavorite)
                    } label: {
                        Label("", systemImage: product.isFavorite ? "heart.fill" : "heart")
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
    ProductInfoView2(product: Product.products[2], selectedMonth: .apr)
}
