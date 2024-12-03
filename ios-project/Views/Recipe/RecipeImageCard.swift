import SwiftUI

struct RecipeImageCard: View {
    @ObservedObject var recipe: Recipe
    @State var isFlipped = false
    @State var isFavoriteButtonTapped = false
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    internal init(recipe: Recipe) {
        self.recipe = recipe
        hapticFeedback.prepare()
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
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.3)]),
                                    startPoint: .center,
                                    endPoint: .topLeading
                                )
                            )
                       .clipShape(.rect(cornerRadius: 16))
                    
                    VStack {
                        
                        HStack {
                            Text("")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                hapticFeedback.impactOccurred()
                                
                                withAnimation(.bouncy(duration: 0.5)){
                                    recipe.isFavorite.toggle()
                                }
                                recipe.saveFavoriteState(for: recipe.id, isFavorite: recipe.isFavorite)
                                hapticFeedback.prepare()
                            }) {
                                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                    .symbolEffect(
                                        .bounce.up,
                                        options: .speed(0.8),
                                        value: recipe.isFavorite
                                    )
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(recipe.isFavorite ? .accentColor.opacity(1) : Color(.white))
                                    .background(
                                        Circle()
                                            .padding(-10)
                                            .foregroundStyle(Color(.systemGray2))
                                            .opacity(0.9)
                                    )
                                    
                            }
                        }
                        .padding([.leading, .trailing], 25)
                        .padding(.bottom, 10)
                        .offset(y: 18)
                    }
                }
            if isFlipped {
                Text("Rezept & Bild stammen von\n\(recipe.source)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))  // Flips the text horizontally

            }
        }
        .shadow(color: .black, radius: 12)
        .padding(.bottom, 8)
        
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
    }
}

#Preview {
    Spacer()
    RecipeImageCard(recipe: Recipe.recipes[23])
}
