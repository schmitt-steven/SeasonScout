import SwiftUI

/// A view that shows detailed information about a recipe, including its image, description, availability, ingredients, and similar recipes.
struct RecipeInfoView: View {
    let recipe: Recipe  // The recipe object to display
    let selectedMonth: Month  // The selected month to show seasonality and availability
    var tagData: [InfoTag] {  // An array of InfoTag objects to display various recipe tags
        [
            InfoTag(type: .recipeCategory, value: recipe.category.rawValue),
            InfoTag(type: .effortLevel, value: recipe.effort),
            InfoTag(type: .isVegetarian, value: recipe.isVegetarian),
            InfoTag(type: .priceLevel, value: recipe.price),
            InfoTag(type: .forGroups, value: recipe.isForGroups),
        ]
    }
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)

    // A computed property to get other recipes in the same category (excluding the current one)
    var recipesOfSameCategory: [Recipe] {
        Recipe.recipes.compactMap { otherRecipe in
            return recipe.category.rawValue == otherRecipe.category.rawValue
                && recipe.id != otherRecipe.id ? otherRecipe : nil
        }
    }

    @State var scrollViewOffset: CGFloat = 0  // Track the offset of the scroll view for navbar opacity
    let startNavbarAnimationOffset: CGFloat = 200  // The offset where the navbar starts becoming visible
    let endNavBarAnimationOffset: CGFloat = 260  // The offset where the navbar is fully visible
    let animationOffsetRange: CGFloat = 60  // Range of scroll offset for the navbar animation

    // Calculates the opacity of the navbar title based on scroll view offset
    var titleOpacity: Double {
        switch scrollViewOffset {
        case ..<startNavbarAnimationOffset:
            return 0  // Navbar is completely hidden before the animation starts
        case endNavBarAnimationOffset...:
            return 1  // Navbar is fully visible once the offset exceeds the end offset
        default:
            return Double(
                (scrollViewOffset - startNavbarAnimationOffset)
                    / animationOffsetRange)
        }
    }

    internal init(
        recipe: Recipe, selectedMonth: Month, scrollViewOffset: CGFloat = 0
    ) {
        self.recipe = recipe
        self.selectedMonth = selectedMonth
        self.scrollViewOffset = scrollViewOffset

        self.hapticFeedback.prepare()
    }

    var body: some View {

        ZStack {
            // Background image for the recipe
            Image(uiImage: UIImage(named: recipe.imageName)!)
                .resizable()
                .scaledToFit()
                .saturation(1.2)
                .hueRotation(.degrees(10))
                .brightness(0.1)
                .frame(
                    maxWidth: .infinity, maxHeight: .infinity,
                    alignment: .topLeading
                )
                .ignoresSafeArea()

            // Blur background effect
            BlurBackgroundView(style: .systemChromeMaterial)
                .ignoresSafeArea()

            // Main scroll view containing recipe details
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {

                    RecipeImageCard(recipe: recipe)

                    // Recipe title and tags
                    VStack {
                        Text(recipe.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)

                        RecipeTagsSection(tagDataList: tagData)

                        // Recipe description
                        Text("Kurzbeschreibung")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.top, 25)
                        GroupBox {
                            VStack(alignment: .leading) {
                                Text(recipe.description)
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)

                        // Availability section based on the selected month
                        Text("Verfügbarkeit")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.top, 25)
                        GroupBox {
                            RecipeSeasonalityStatusView(
                                seasonalData: recipe.seasonalData,
                                selectedMonth: selectedMonth
                            )
                            .frame(maxWidth: .infinity)
                        }

                        // Ingredients availability chart (Expandable)
                        ExpandableGroupBox(title: "Zutatenverfügbarkeit") {
                            RecipePieChart(
                                seasonalData: recipe.seasonalData,
                                selectedMonth: selectedMonth
                            )
                        }

                        // Ingredients list (Expandable)
                        ExpandableGroupBox(title: "Zutaten") {
                            RecipeIngredientTable(
                                ingredientList: recipe.ingredientsByPersons)
                        }

                        // Recipe preparation steps (Expandable)
                        ExpandableGroupBox(title: "Zubereitung") {
                            RecipeInstructionsView(
                                instructions: recipe.instructions
                            )
                            .frame(maxWidth: .infinity)
                        }

                        // Similar recipes section
                        Text("Ähnliche Gerichte")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                            .padding(.top, 25)
                        SimilarRecipesView(
                            recipe: recipe, selectedMonth: selectedMonth
                        )
                        .frame(maxWidth: .infinity)

                        // Footer with page information
                        VStack(alignment: .leading, spacing: 10) {
                            Divider()

                            Text("Informationen zur Seite")
                                .font(.title3.bold())
                                .foregroundColor(.gray)
                            Text(
                                "Informationen/Bilder stammen von der Webseite \(recipe.source)"
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
                // Dynamic navbar title based on scroll offset
                if self.scrollViewOffset > self.startNavbarAnimationOffset {
                    ToolbarItem(placement: .principal) {
                        Text(recipe.title)
                            .font(.headline)
                            .opacity(titleOpacity)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                // Heart button for liking the recipe
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hapticFeedback.impactOccurred()
                        hapticFeedback.prepare()
                    }) {
                        RecipeHeartView(recipe: recipe, scale: 1.0)
                    }
                }
            }
            // Handle background and other UI behaviors
            .ignoresSafeArea(edges: .all)
            .scrollIndicators(.hidden)
            .onAppear {
                scrollViewOffset += 1  // Simulate scroll to trigger navbar opacity update
            }
            // Link to scroll view offset and navbar animation
            .navBarOffset(
                $scrollViewOffset, start: startNavbarAnimationOffset,
                end: endNavBarAnimationOffset
            )
            .scrollViewOffset($scrollViewOffset)

        }

    }
}

#Preview {
    let recipe = Recipe.recipes[55]
    RecipeInfoView(recipe: recipe, selectedMonth: .nov)
}
