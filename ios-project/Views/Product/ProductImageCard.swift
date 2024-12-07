//
//  ProductImageCard.swift
//  ios-project
//
//  Created by Henry Harder on 07.12.24.
//

import SwiftUI

struct ProductImageCard: View {
    @ObservedObject var product: Product
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    internal init(product: Product) {
        self.product = product
        hapticFeedback.prepare()
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                    
                    Image(uiImage: UIImage(named: product.imageName)!)
                        .resizable()
                        .scaledToFit()
                        .saturation(1.3)
                        .brightness(0.07)
                        .background(.clear)
                        .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.3)]),
                                    startPoint: .center,
                                    endPoint: .topLeading
                                )
                            )
                       .clipShape(.rect(cornerRadius: 16))
                }
        }
        .shadow(color: .black, radius: 5)
        .padding(.bottom, 8)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    Spacer()
    ProductImageCard(product: Product.products[65])
}
