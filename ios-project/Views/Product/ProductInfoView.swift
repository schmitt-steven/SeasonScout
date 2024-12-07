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
    
    @State var scrollViewOffset: CGFloat = 0
    let startNavbarAnimationOffset: CGFloat = 200
    let endNavBarAnimationOffset: CGFloat = 260
    let animationOffsetRange: CGFloat = 60
    
    var titleOpacity: Double {
        switch scrollViewOffset {
        case ..<startNavbarAnimationOffset:
            return 0
        case endNavBarAnimationOffset...:
            return 1
        default:
            return Double((scrollViewOffset - startNavbarAnimationOffset) / animationOffsetRange)
        }
    }
    internal init(product: Product, selectedMonth: Month, scrollViewOffset: CGFloat = 0) {
        self.product = product
        self.selectedMonth = selectedMonth
        self.scrollViewOffset = scrollViewOffset
        hapticFeedback.prepare()
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: product.imageName)!)
                .resizable()
                .scaledToFit()
                .saturation(1.2)
                .hueRotation(.degrees(10))
                .brightness(0.1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .ignoresSafeArea()
            
            BlurBackgroundView(style: .systemChromeMaterial)
                .ignoresSafeArea()
            
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        ProductImageCard(product: product)

                        VStack{
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

                            VStack(alignment: .leading, spacing: 10) {
                                Divider()
                                
                                Text("Informationen zur Seite")
                                    .font(.title3.bold())
                                    .foregroundColor(.gray)
                                Text("Informationen/Bilder stammen von der Webseite \(product.imageSource)")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        .padding()
                        Spacer()
                            .frame(height: UINavigationController().navigationBar.frame.height + 50)
                    }
                }
                .toolbar {
                    if self.scrollViewOffset > self.startNavbarAnimationOffset {
                        ToolbarItem(placement: .principal) {
                            Text(product.name)
                                .font(.headline)
                                .opacity(titleOpacity)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
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
                .navBarOffset($scrollViewOffset, start: startNavbarAnimationOffset, end: endNavBarAnimationOffset)
                .scrollViewOffset($scrollViewOffset)
            
        }

    }
}

#Preview {
    let product = Product.products[65]
    ProductInfoView(product: product, selectedMonth: .nov)
}
