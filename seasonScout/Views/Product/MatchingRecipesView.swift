import SwiftUI

/// A view that displays recipes containing the selected product as an ingredient
/// and shows availability for the selected month.
struct MatchingRecipesView: View {
    let product: Product
    let selectedMonth: Month
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme

    // Filtered recipes that contain the selected product as an ingredient
    var filteredRecipes: [Recipe] {
        Recipe.recipes.filter { recipe in
            recipe.ingredientsByPersons.flatMap { $0.ingredients }
                .contains { $0.name.contains(product.name) }
        }
    }

    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        let isLightMode = colorScheme == .light

        ScrollView(.horizontal) {
            HStack {
                if filteredRecipes.isEmpty {
                    // Show message when no recipes match
                    Text("Keine Gerichte verfügbar.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Loop through the filtered recipes and display them
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink(
                            destination: RecipeInfoView(
                                recipe: recipe, selectedMonth: selectedMonth)
                        ) {
                            GroupBox {
                                VStack {
                                    HStack {
                                        // Display recipe image
                                        Image(
                                            uiImage: UIImage(
                                                named: recipe.imageName)!
                                        )
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .cornerRadius(8)
                                        .foregroundStyle(.secondary)

                                        VStack(alignment: .leading, spacing: 2)
                                        {
                                            // Display recipe title with truncation if needed
                                            Text(recipe.title)
                                                .font(.headline.bold())
                                                .padding(.bottom, 5)
                                                .lineLimit(2)
                                                .truncationMode(.tail)

                                            // Display availability for the selected month
                                            if let seasonalData =
                                                seasonalDataForSelectedMonth(
                                                    recipe: recipe)
                                            {
                                                RecipeAvailabilityView(
                                                    availability: seasonalData)
                                            } else {
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
                            .containerRelativeFrame(
                                .horizontal,
                                count: verticalSizeClass == .regular
                                    ? 1 : 4,  // Adjust layout based on vertical size class
                                spacing: 16
                            )
                            .scrollTransition { content, phase in
                                let brightnessValue = isLightMode ? -0.05 : 0.05

                                return
                                    content
                                    .opacity(phase.value == 0 ? 1 : 0.95)
                                    .brightness(phase.value == 0 ? 0 : brightnessValue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollClipDisabled()  // Disable clipping for better scrolling performance
        .contentMargins(16, for: .scrollContent)  // Add margins around the scroll content
        .scrollTargetBehavior(.viewAligned)  // Align views during scrolling
    }

    // Function to check the availability of the product for the selected month in the recipe
    private func seasonalDataForSelectedMonth(recipe: Recipe)
        -> RecipeSeasonalMonthData?
    {
        return recipe.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
