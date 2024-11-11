import SwiftUI

struct RecipeImageCard: View {
    let recipe: Recipe
    @State private var isFlipped = false
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {

                Image(uiImage: UIImage(named: recipe.imageName)!)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.95)
                    .blur(radius: 0.2)
                    .background(.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                VStack {

                    HStack {
                        Text(recipe.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .modifier(TextShadowEffect(color: .black.opacity(0.8), radius: 2, x: 1, y: 1))
                            .modifier(TextShadowEffect(color: .black.opacity(0.6), radius: 4, x: 2, y: 2))
                            .modifier(TextShadowEffect(color: .black.opacity(0.4), radius: 8, x: 3, y: 3))
                            .modifier(TextShadowEffect(color: .white.opacity(0.2), radius: 12, x: 4, y: 4))
                            .modifier(GlowEffect())
                            .modifier(InnerShadowEffect())
                        
                        Spacer()
                        
                        Button(action: {
                            // TODO: Persistent Favorization
                        }) {
                            Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(recipe.isFavorite ? .red : .white)
                                .modifier(TextShadowEffect(color: .black.opacity(0.8), radius: 2, x: 1, y: 1))
                                .modifier(TextShadowEffect(color: .black.opacity(0.6), radius: 4, x: 2, y: 2))
                                .modifier(TextShadowEffect(color: .black.opacity(0.4), radius: 8, x: 3, y: 3))
                                .modifier(TextShadowEffect(color: .white.opacity(0.2), radius: 12, x: 4, y: 4))
                                .modifier(GlowEffect())
                                .modifier(InnerShadowEffect())
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .padding(.bottom, 10)
                }
            }
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .blur(radius: isFlipped ? 2 : 0)
            
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
        .padding([.horizontal], 20)
        .padding(.bottom, 5)
        .shadow(color: .black.opacity(0.7), radius: 12)
        
        // Makes the view (dis)appear gradually when scrolling
        .visualEffect { content, proxy in
            let offset = proxy.frame(in: .global).minY
            let scaleFactor = min(1 + (offset / 800), 1)
            let opacity = min(1, 1 - (-offset / 400))
            let blurRadius = -offset / 200
            return content
                .scaleEffect(scaleFactor)
                .opacity(opacity)
                .blur(radius: blurRadius)
        }
        
        // Flips the entire view horizontally (when tapped)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation(.interpolatingSpring(duration: 0.7)) {
                isFlipped.toggle()
            }
        }
    }
}