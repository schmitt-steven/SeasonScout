import SwiftUI

/// A view that displays similar recipes from the same category, excluding the current recipe.
struct SimilarRecipesView: View {
    // The current recipe being displayed.
    let recipe: Recipe
    // The selected month, used to determine availability of ingredients.
    let selectedMonth: Month
    // A list of recipes from the same category as the current recipe.
    let recipesOfSameCategory: [Recipe]
    // The vertical size class of the device (used to adjust layout for different screen sizes).
    @Environment(\.verticalSizeClass) var verticalSizeClass

    // Custom initializer that filters recipes from the same category as the current recipe.
    init(recipe: Recipe, selectedMonth: Month) {
        self.recipe = recipe
        self.selectedMonth = selectedMonth
        // Filter recipes based on the same category but excluding the current recipe by its ID.
        self.recipesOfSameCategory = Recipe.recipes.filter { otherRecipe in
            otherRecipe.category == recipe.category
                && otherRecipe.id != recipe.id
        }
    }

    var body: some View {
        // Horizontal scroll view to display the list of similar recipes.
        ScrollView(.horizontal) {
            HStack {
                // If no similar recipes are found, display a message.
                if recipesOfSameCategory.isEmpty {
                    Text("Keine Gerichte verfügbar.")  // Text when no similar recipes are available.
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Iterate through the filtered list of similar recipes and display them.
                    ForEach(recipesOfSameCategory) { otherRecipe in
                        // Navigation link to show the detailed view of the selected recipe.
                        NavigationLink(
                            destination: RecipeInfoView(
                                recipe: otherRecipe,
                                selectedMonth: selectedMonth)
                        ) {
                            GroupBox {
                                VStack {
                                    HStack {
                                        // Display recipe image.
                                        Image(
                                            uiImage: UIImage(
                                                named: otherRecipe.imageName)!
                                        )
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .cornerRadius(8)
                                        .foregroundStyle(.secondary)

                                        VStack(alignment: .leading, spacing: 2)
                                        {
                                            // Recipe title
                                            Text(otherRecipe.title)
                                                .font(.headline.bold())
                                                .padding(.bottom, 5)
                                                .lineLimit(2)
                                                .truncationMode(.tail)

                                            // Display availability of the recipe for the selected month.
                                            if let seasonalData =
                                                seasonalDataForSelectedMonth(
                                                    recipe: otherRecipe)
                                            {
                                                RecipeAvailabilityView(
                                                    availability: seasonalData)
                                            } else {
                                                // If the recipe is not available in the selected month.
                                                Text(
                                                    "Nicht verfügbar im \(selectedMonth.rawValue)"
                                                )
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            // Adjust the layout of the recipe view based on screen size.
                            .containerRelativeFrame(
                                .horizontal,
                                count: verticalSizeClass == .regular ? 1 : 4,
                                spacing: 16
                            )
                            // Scroll transition effect when content scrolls.
                            .scrollTransition { content, phase in
                                return
                                    content
                                    .opacity(phase.value == 0 ? 1 : 0.5)
                            }
                        }
                        // Remove button style to keep a custom appearance.
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .scrollTargetLayout()  // Enable scroll target layout for smooth scrolling.
        }
        .scrollClipDisabled()  // Disable clipping of scroll content.
        .contentMargins(16, for: .scrollContent)  // Add margins to the scroll content.
        .scrollTargetBehavior(.viewAligned)  // Ensure content scrolls in a view-aligned manner.
    }

    // A helper function to check if the recipe is available in the selected month.
    private func seasonalDataForSelectedMonth(recipe: Recipe)
        -> RecipeSeasonalMonthData?
    {
        // Return the seasonal data for the selected month if available.
        return recipe.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
