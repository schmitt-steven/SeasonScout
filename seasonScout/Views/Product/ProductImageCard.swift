import SwiftUI

/// A view that displays a product's image in a styled card format with visual effects.
/// The image is shown with a gradient overlay and is designed to adapt its appearance based on the scroll position.
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
                // Display product image with effects such as saturation and brightness adjustment
                Image(uiImage: UIImage(named: product.imageName)!)
                    .resizable()
                    .scaledToFit()
                    .saturation(1.3)
                    .brightness(0.07)
                    .background(.clear)
                    .overlay(
                        // Apply a linear gradient overlay from transparent to dark (black) to create a fading effect
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear, .black.opacity(0.7),
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .clipShape(.rect(cornerRadius: 16))
            }
        }
        .shadow(color: .black, radius: 5)
        .padding(.bottom, 8)
        .ignoresSafeArea(.all)
        .padding(.top, -10)
        // Apply a custom visual effect that alters the image's appearance based on the scroll offset
        .visualEffect { content, proxy in
            let offset = proxy.frame(in: .global).minY
            let height = proxy.size.height
            let yOffset = max(-offset, -height)
            let opacity = min(1, 1 - (-offset / 200))
            let blurRadius = -offset / 100

            return
                content
                .offset(y: yOffset)
                .opacity(opacity)
                .blur(radius: blurRadius)
        }
    }
}

#Preview {
    Spacer()
    ProductImageCard(product: Product.products[65])
}
