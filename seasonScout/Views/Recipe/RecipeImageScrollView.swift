import SwiftUI

/// A horizontally scrolling view displaying a list of recipe images with titles and various visual effects.
struct RecipeImageScrollView: View {
    let recipes: [Recipe]  // Array of Recipe objects to be displayed in the scroll view

    var body: some View {
        // Horizontal scroll view that allows scrolling through the recipe images
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(recipes, id: \.id) { recipe in
                    // For each recipe, create a clickable navigation link
                    NavigationLink(
                        destination: RecipeInfoView(
                            recipe: recipe, selectedMonth: .jan)
                    ) {
                        ZStack(alignment: .bottom) {
                            // Recipe image with additional visual effects (resizable, saturation, brightness, and clipping)
                            Image(uiImage: UIImage(named: recipe.imageName)!)
                                .resizable()
                                .scaledToFit()
                                .saturation(1.3)
                                .brightness(0.07)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(radius: 10)
                                .scrollTransition(axis: .horizontal) {
                                    content, phase in
                                    content
                                        .rotationEffect(
                                            .degrees(phase.value * 1.5))
                                }

                            // Overlay with the recipe title
                            HStack {
                                Text(recipe.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .modifier(TextShadowEffect())
                                    .modifier(GlowEffect())
                                    .modifier(InnerShadowEffect())
                                    .padding(15)
                                Spacer()
                            }
                        }
                    }
                    .navigationTitle(Text(""))  // Empty navigation title for this view
                    .buttonStyle(PlainButtonStyle())
                }
                .containerRelativeFrame(.horizontal)
            }
            .scrollTargetLayout()
        }
        .scrollClipDisabled()
        .contentMargins([.horizontal, .bottom], 20, for: .scrollContent)
        .contentMargins(.top, 20, for: .scrollContent)
        .contentMargins(.horizontal, 20, for: .scrollIndicators)
        .contentMargins(.bottom, 5, for: .scrollIndicators)
        .scrollTargetBehavior(.paging)
    }
}
