import SwiftUI

/// A view that displays a list of products with an optional message if no products are available.
struct ProductListView: View {
    let products: [Product]  // Array of products to be displayed
    @Binding var selectedMonth: Month  // Binding to the selected month to filter products
    let searchText: String

    var body: some View {
        ScrollView {
            // If there are no products, show a message
            if products.isEmpty {
                if !searchText.isEmpty {
                    Text("Mit deiner Eingabe konnten keine Produkte gefunden werden!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding([.horizontal, .top, .bottom], 22)
                } else {
                    VStack(spacing: 6) {
                        Text(
                            "Du hast noch keine Produkte zu Deinen Favoriten hinzugefügt!"
                        )
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text(
                            "Um ein Produkt zu favorisieren, wähle ein Produkt aus und tippe auf das Herz in der oberen rechten Ecke."
                        )
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding([.horizontal, .top, .bottom], 22)
                }
            } else {
                // If there are products, display them in a LazyVStack for efficient rendering
                LazyVStack(spacing: 10) {
                    ForEach(products) { product in
                        // Each product is displayed using the `ProductRowView`
                        ProductRowView(
                            product: product, selectedMonth: $selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)

            }
        }

    }
}
