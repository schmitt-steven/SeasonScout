import SwiftUI

/// A view that provides filter options for selecting categories, effort levels, prices, and dietary preferences.
struct RecipeFilterView: View {
    // Binding properties to pass selected filter values back to the parent view
    @Binding var selectedRecipeCategory: RecipeCategory?
    @Binding var selectedRecipeEffort: Level?
    @Binding var selectedRecipePrice: Level?
    @Binding var selectedRecipeIsForGroups: Bool
    @Binding var selectedRecipeIsVegetarian: Bool

    var body: some View {
        List {
            // Section for Category, Effort, and Price filters
            Section {
                // Category Picker
                HStack {
                    Image(systemName: "tag.fill") // Icon for category
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBlue))) // Background color for the icon
                    
                    Picker("Kategorie", selection: $selectedRecipeCategory) {
                        Text("Alle").tag(nil as RecipeCategory?) // Default "All" option
                        // Loop through all categories and present them in the picker
                        ForEach(RecipeCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category as RecipeCategory?)
                        }
                    }
                    .pickerStyle(.navigationLink) // Use the navigation link style for the picker
                }

                // Effort Picker
                HStack {
                    Image(systemName: "clock.fill") // Icon for effort level
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemIndigo))) // Background color for the icon
                    
                    Picker("Aufwand", selection: $selectedRecipeEffort) {
                        Text("egal").tag(nil as Level?) // Default "Any" option
                        // Loop through all effort levels and present them in the picker
                        ForEach(Level.allCases, id: \.self) { effort in
                            Text(effort.rawValue).tag(effort as Level?)
                        }
                    }
                    .pickerStyle(.navigationLink) // Use the navigation link style for the picker
                }

                // Price Picker
                HStack {
                    Image(systemName: "eurosign.circle.fill") // Icon for price level
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(.gray)) // Background color for the icon
                    
                    Picker("Kosten", selection: $selectedRecipePrice) {
                        Text("egal").tag(nil as Level?) // Default "Any" option
                        // Loop through all price levels and present them in the picker
                        ForEach(Level.allCases, id: \.self) { price in
                            Text(price.rawValue).tag(price as Level?)
                        }
                    }
                    .pickerStyle(.navigationLink) // Use the navigation link style for the picker
                }
            }

            // Section for dietary filters
            Section {
                // For Groups Picker
                HStack {
                    Image(systemName: selectedRecipeIsForGroups ? "person.badge.plus" : "person") // Icon based on whether the filter is selected
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(.black)) // Background color for the icon
                    
                    // NavigationLink to the toggle view for "For Groups" filter
                    NavigationLink(
                        destination: ToggleView(
                            isOn: $selectedRecipeIsForGroups, // Bind the state of the toggle
                            title: "Für Gruppen",
                            footer:
                                "Beachte, dass nur die Rezepte für Gruppen des ausgewählten Monats angezeigt werden." // Footer description
                        )
                    ) {
                        HStack {
                            Text("Für Gruppen") // Text for the filter
                            Spacer()
                            Text(selectedRecipeIsForGroups ? "Ja" : "Nein") // Show the current state (Yes/No)
                                .foregroundStyle(.gray)
                        }
                    }
                }

                // Vegetarian Picker
                HStack {
                    Image(systemName: "fork.knife.circle.fill") // Icon for vegetarian filter
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(selectedRecipeIsVegetarian ? .green : .red)) // Background color based on the filter status
                    
                    // NavigationLink to the toggle view for "Vegetarian" filter
                    NavigationLink(
                        destination: ToggleView(
                            isOn: $selectedRecipeIsVegetarian, // Bind the state of the toggle
                            title: "Vegetarisch",
                            footer:
                                "Beachte, dass nur die vegetarischen Rezepte des ausgewählten Monats angezeigt werden." // Footer description
                        )
                    ) {
                        HStack {
                            Text("Vegetarisch") // Text for the filter
                            Spacer()
                            Text(selectedRecipeIsVegetarian ? "Ja" : "Nein") // Show the current state (Yes/No)
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }

        }
        .navigationTitle("Weitere Filter") // Title for the navigation bar
        .navigationBarTitleDisplayMode(.inline) // Set the title display mode to inline
    }
}

/// A view that shows a toggle switch for enabling or disabling a specific filter.
struct ToggleView: View {
    // Binding to the toggle state
    @Binding var isOn: Bool
    var title: String // Title of the toggle section
    var footer: String // Description to display below the toggle

    var body: some View {
        List {
            Section(footer: Text(footer)) { // Section with footer text
                // Toggle switch to enable/disable the filter
                Toggle(isOn: $isOn) {
                    Text(title) // Text for the toggle switch
                }
            }
        }
        .navigationTitle(title) // Set the title of the navigation bar to the title of the toggle section
    }
}
