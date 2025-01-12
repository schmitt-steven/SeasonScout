import SwiftUI

/// A view that displays a horizontal scroll list of products that share the same subtype as the current product.
/// The list includes the product name, botanical name, and availability for the selected month.
struct SimilarProductsView: View {
    let product: Product
    let selectedMonth: Month
    let productsOfSameSubtype: [Product]  // A list of products with the same subtype as the current product

    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme

    init(product: Product, selectedMonth: Month) {
        self.product = product
        self.selectedMonth = selectedMonth
        self.productsOfSameSubtype = Product.products.filter { otherProduct in
            // Filter products that share the same subtype, excluding the current product
            otherProduct.subtype == product.subtype
                && otherProduct.id != product.id
        }
    }

    var body: some View {
        let isLightMode = colorScheme == .light

        ScrollView(.horizontal) {
            HStack {
                if productsOfSameSubtype.isEmpty {
                    // Show a message if no similar products are found
                    GroupBox {
                        Text("Keine Produkte gefunden.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    // Iterate over the filtered products and display each one
                    ForEach(productsOfSameSubtype) { product in
                        // Navigation link that takes the user to the product's detail page
                        NavigationLink(
                            destination: ProductInfoView(
                                product: product, selectedMonth: selectedMonth)
                        ) {
                            GroupBox {
                                VStack {
                                    HStack {
                                        // Display a placeholder image if the product doesn't have an image
                                        if product.imageName.isEmpty {
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: 80, height: 80)
                                                .foregroundStyle(.secondary)
                                        } else {
                                            // Display the product image if available
                                            Image(
                                                uiImage: UIImage(
                                                    named: product.imageName)!
                                            )
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                            .cornerRadius(8)
                                            .foregroundStyle(.secondary)
                                        }

                                        VStack(alignment: .leading, spacing: 2)
                                        {
                                            Text(product.name)
                                                .font(.headline.bold())

                                            Text(product.botanicalName)
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                                .padding(.bottom, 5)

                                            // Availability for the selected month
                                            if let seasonalData =
                                                seasonalDataForSelectedMonth()
                                            {
                                                AvailabilityView(
                                                    availability: seasonalData)
                                            } else {
                                                Text(
                                                    "Nicht verfügbar im \(selectedMonth.rawValue)"
                                                )
                                                .font(.subheadline)
                                                .foregroundColor(
                                                    Color(
                                                        UIColor
                                                            .systemGroupedBackground
                                                    ))
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
                            // Animation during scrolling transition
                            .scrollTransition { content, phase in
                                let brightnessValue = isLightMode ? -0.05 : 0.05

                                return
                                    content
                                    .opacity(phase.value == 0 ? 1 : 0.95)
                                    .brightness(phase.value == 0 ? 0 : brightnessValue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollClipDisabled()
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }

    // Function to check if the product is available in the selected month
    private func seasonalDataForSelectedMonth() -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == selectedMonth })

    }
}
