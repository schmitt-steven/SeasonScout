import SwiftUI

struct RecipeImageCard: View {
    @ObservedObject var recipe: Recipe
    
    internal init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                    
                    Image(uiImage: UIImage(named: recipe.imageName)!)
                        .resizable()
                        .scaledToFit()
                        .saturation(1.3)
                        .brightness(0.07)
                        .background(.clear)
                        .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                       .clipShape(.rect(cornerRadius: 16))
                }
        }
        .shadow(color: .black, radius: 5)
        .ignoresSafeArea(.all)

        // Makes the view move behind the scroll view and fade in/out based on the current offset
        .visualEffect { content, proxy in
            let offset = proxy.frame(in: .global).minY
            let height = proxy.size.height
            let yOffset = max(-offset, -height)
            let opacity = min(1, 1 - (-offset / 200))
            let blurRadius = -offset / 100

            return content
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
