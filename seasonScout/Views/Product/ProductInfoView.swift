import SwiftUI

/// A view that displays detailed information about a product, including its image, description, availability, similar products, and recipes.
/// It also provides dynamic title opacity based on the scroll offset.
struct ProductInfoView: View {
    @ObservedObject var product: Product
    let selectedMonth: Month
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)

    @State var scrollViewOffset: CGFloat = 0
    let startNavbarAnimationOffset: CGFloat = 200
    let endNavBarAnimationOffset: CGFloat = 260
    let animationOffsetRange: CGFloat = 60

    // Dynamic title opacity based on the scroll position
    var titleOpacity: Double {
        switch scrollViewOffset {
        case ..<startNavbarAnimationOffset:
            return 0  // Hide title when scrolling before the start offset
        case endNavBarAnimationOffset...:
            return 1  // Fully show title when scrolling past the end offset
        default:
            return Double(
                (scrollViewOffset - startNavbarAnimationOffset)
                    / animationOffsetRange)
        }
    }
    internal init(
        product: Product, selectedMonth: Month, scrollViewOffset: CGFloat = 0
    ) {
        self.product = product
        self.selectedMonth = selectedMonth
        self.scrollViewOffset = scrollViewOffset
        hapticFeedback.prepare()
    }

    var body: some View {
        ZStack {
            ProductImageCard(product: product)
                .frame(
                    maxWidth: .infinity, maxHeight: .infinity,
                    alignment: .topLeading
                )
                .ignoresSafeArea()

            // Apply a blurred background view
            BlurBackgroundView(style: .systemChromeMaterial)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Display product image
                    ProductImageCard(product: product)

                    VStack {
                        // Product name with styling
                        Text(product.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, -10)

                        // Botanical name of the product, styled in a smaller font
                        Text(product.botanicalName)
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding(.bottom, -10)

                        // Short description section with a title
                        Text("Kurzbeschreibung")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.top, 25)
                        GroupBox {
                            VStack(alignment: .leading) {
                                Text(product.description)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)

                        // Availability section with a title and product availability for the selected month
                        Text("Verfügbarkeit")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.top, 25)
                        AvailabilityMonthView(
                            product: product, selectedMonth: selectedMonth)

                        // Similar products section with a title
                        Text("Ähnliche Produkte")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.top, 25)
                        SimilarProductsView(
                            product: product, selectedMonth: selectedMonth
                        )
                        .frame(maxWidth: .infinity)

                        // Matching recipes section with a title
                        Text("Passende Rezepte")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.top, 25)
                        MatchingRecipesView(
                            product: product, selectedMonth: selectedMonth
                        )
                        .frame(maxWidth: .infinity)

                        // Footer section with information about the page and image source
                        VStack(alignment: .leading, spacing: 10) {
                            Divider()

                            Text("Informationen zur Seite")
                                .font(.title3.bold())
                                .foregroundColor(.gray)
                            Text(
                                "Informationen/Bilder stammen von der Webseite \(product.imageSource)"
                            )
                            .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    .padding()
                    Spacer()
                        .frame(
                            height: UINavigationController().navigationBar.frame
                                .height + 50)
                }
            }
            .toolbar {
                // Show the product name in the navigation bar when scrolling past a certain point
                if self.scrollViewOffset > self.startNavbarAnimationOffset {
                    ToolbarItem(placement: .principal) {
                        Text(product.name)
                            .font(.headline)
                            .opacity(titleOpacity)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                // Button for adding the product to favorites
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hapticFeedback.impactOccurred()
                        hapticFeedback.prepare()
                    }) {
                        ProductHeartView(product: product)
                    }
                }
            }
            .ignoresSafeArea(edges: .all)
            .scrollIndicators(.hidden)
            .onAppear {
                scrollViewOffset += 1
            }
            .navBarOffset(
                $scrollViewOffset, start: startNavbarAnimationOffset,
                end: endNavBarAnimationOffset
            )
            .scrollViewOffset($scrollViewOffset)

        }

    }
}

#Preview {
    let product = Product.products[40]
    ProductInfoView(product: product, selectedMonth: .nov)
}
