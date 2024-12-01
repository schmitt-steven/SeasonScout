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
        ScrollView {
            if productsOfSameSubtype.isEmpty {
                // Anzeige einer Nachricht bei leerer Produktliste
                Text("Keine Produkte verfügbar.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(productsOfSameSubtype) { otherProduct in
                        ProductRowView(product: otherProduct, selectedMonth: selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
        .navigationTitle("Ähnliche Produkte")
    }
}
