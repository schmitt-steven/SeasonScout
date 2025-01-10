//
//  ProductListView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct ProductListView: View {
    let products: [Product]
    @Binding var selectedMonth: Month

    var body: some View {
        ScrollView {
            if products.isEmpty {
                VStack(spacing: 6){
                    Text("Du hast noch keine Produkte zu Deinen Favoriten hinzugefügt!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Um ein Produkt zu favorisieren, wähle ein Produkt aus und tippe auf das Herz in der oberen rechten Ecke.")
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                .padding([.horizontal, .top, .bottom], 22)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(products) { product in
                        ProductRowView(product: product, selectedMonth: $selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                
            }
        }
        
        
    }
}
