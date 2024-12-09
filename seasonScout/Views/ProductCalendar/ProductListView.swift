//
//  ProductListView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct ProductListView: View {
    let products: [Product]
    let selectedMonth: Month

    var body: some View {
        ScrollView {
            if products.isEmpty {
                // Anzeige einer Nachricht bei leerer Produktliste
                Text("Keine Produkte verfügbar.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(products) { product in
                        ProductRowView(product: product, selectedMonth: selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
    }
}
