import SwiftUI

/// A view that displays a list of recipes or a message when no recipes are available.
struct RecipeListView: View {
    let recipes: [Recipe]  // Array of recipes to display
    @Binding var selectedMonth: Month  // Binding for the selected month (used to filter recipes)
    let searchText: String

    var body: some View {
        ScrollView {  // This makes the content scrollable
            // Check if there are no recipes
            if recipes.isEmpty {
                if !searchText.isEmpty {
                    Text(
                        "Mit deiner Eingabe konnten keine Rezepte gefunden werden!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding([.horizontal, .top, .bottom], 22)
                } else {
                    // Show a message when there are no recipes
                    VStack(spacing: 6) {
                        Text(
                            "Du hast noch keine Rezepte zu Deinen Favoriten hinzugefügt!"
                        )  // Message when no recipes are added
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(
                            "Um ein Rezept zu favorisieren, wähle ein Rezept aus und tippe auf das Herz in der oberen rechten Ecke."
                        )  // Instructions for adding a favorite
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.horizontal, .top, .bottom], 20)
                }
            } else {
                // Display the recipes in a scrollable stack
                LazyVStack(spacing: 10) {
                    ForEach(recipes) { recipe in
                        // Each recipe is rendered using the RecipeRowView
                        RecipeRowView(
                            recipe: recipe, selectedMonth: $selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
    }
}
