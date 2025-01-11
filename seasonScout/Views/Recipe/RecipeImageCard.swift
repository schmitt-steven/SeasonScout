import SwiftUI

/// A view displaying a recipe image with a gradient overlay, blur effects, and parallax-like scrolling effects.
struct RecipeImageCard: View {
    @ObservedObject var recipe: Recipe

    internal init(recipe: Recipe) {
        self.recipe = recipe
    }

    var body: some View {
        ZStack(alignment: .center) {
            // This ZStack holds the image and gradient overlay/
            ZStack(alignment: .bottom) {
                // The main recipe image with additional visual effects
                Image(uiImage: UIImage(named: recipe.imageName)!)
                    .resizable()
                    .scaledToFit()
                    .saturation(1.3)
                    .brightness(0.07)
                    .background(.clear)
                    .overlay(
                        // Linear gradient overlay for a smooth fade effect at the bottom of the image
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
        .ignoresSafeArea(.all)
        // Visual effects that add a parallax-like scroll effect with fade and blur
        .visualEffect { content, proxy in
            let offset = proxy.frame(in: .global).minY
            let height = proxy.size.height
            let yOffset = max(-offset, -height)  // Y offset for the parallax effect (moves the image based on scroll position)
            let opacity = min(1, 1 - (-offset / 200))  // Calculate opacity based on scroll position to create a fade-in/out effect
            let blurRadius = -offset / 100  // Apply blur radius based on the scroll position for a blur effect when scrolling

            // Return the modified content with the applied effects
            return
                content
                .offset(y: yOffset)
                .opacity(opacity)
                .blur(radius: blurRadius)
        }
        .padding(.top, -10)

    }
}

#Preview {
    Spacer()
    RecipeImageCard(recipe: Recipe.recipes[23])
}
