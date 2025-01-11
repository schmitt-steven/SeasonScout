import SwiftUI

/// A view that displays a calendar-like interface to browse recipes by month and applies various filters.
struct RecipeCalendarView: View {
    // AppStorage allows saving dark mode preference across app sessions
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    // State variables to control the filter conditions and selected month
    @State private var searchText = ""  // Text input for searching recipes
    @State private var selectedMonth = Month.allCases[
        Calendar.current.component(.month, from: Date()) - 1]  // Default to the current month
    @State private var excludeNotRegionallyRecipes = true  // Whether to exclude non-regional recipes
    @State private var showFilters = false  // Controls whether filter options are displayed
    @State private var selectedRecipeCategory: RecipeCategory? = nil  // Filter by category
    @State private var selectedRecipeEffort: Level? = nil  // Filter by effort level
    @State private var selectedRecipePrice: Level? = nil  // Filter by price level
    @State private var selectedRecipeIsFavorite = false  // Filter by favorite status
    @State private var selectedRecipeIsForGroups = false  // Filter by suitability for groups
    @State private var selectedRecipeIsVegetarian = false  // Filter by vegetarian status

    // Computed property that filters the recipes based on the selected filters and search text
    var filteredRecipes: [Recipe] {
        RecipeFilter.filter(
            items: Recipe.recipes,
            searchText: searchText,
            selectedRecipeCategory: selectedRecipeCategory,
            selectedRecipeEffort: selectedRecipeEffort,
            selectedRecipePrice: selectedRecipePrice,
            selectedRecipeIsFavorite: selectedRecipeIsFavorite,
            selectedRecipeIsForGroups: selectedRecipeIsForGroups,
            selectedRecipeIsVegetarian: selectedRecipeIsVegetarian,
            excludeNotRegionallyRecipes: excludeNotRegionallyRecipes,
            selectedMonth: selectedMonth
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Display MonthSelectionView unless the 'Favorite' filter is enabled
                if !selectedRecipeIsFavorite {
                    MonthSelectionView(selectedMonth: $selectedMonth)
                }

                // Display filter options when 'showFilters' is true
                if showFilters {
                    VStack {
                        // Toggle to exclude non-regional recipes
                        Toggle(
                            "Nicht regionale Rezepte ausblenden",
                            isOn: $excludeNotRegionallyRecipes
                        )
                        .toggleStyle(.switch)
                        .padding(.bottom, 2)

                        // NavigationLink to show more filter options
                        NavigationLink(
                            destination: RecipeFilterView(
                                selectedRecipeCategory: $selectedRecipeCategory,
                                selectedRecipeEffort: $selectedRecipeEffort,
                                selectedRecipePrice: $selectedRecipePrice,
                                selectedRecipeIsForGroups:
                                    $selectedRecipeIsForGroups,
                                selectedRecipeIsVegetarian:
                                    $selectedRecipeIsVegetarian
                            )
                        ) {
                            HStack {
                                Text("Weitere Filter anzeigen")
                                    .font(.headline)
                                    .foregroundColor(
                                        isDarkModeEnabled ? .white : .black)

                                // Chevron symbol to indicate more filters
                                Image(systemName: "chevron.right")
                                    .font(.headline)
                                    .foregroundStyle(Color.orange)
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 2)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 1.0, anchor: .top),
                            removal: .opacity)
                    )
                    .animation(
                        .spring(
                            response: 0.4, dampingFraction: 0.75,
                            blendDuration: 0.5), value: showFilters)
                }

                // Display the list of filtered recipes
                RecipeListView(
                    recipes: filteredRecipes, selectedMonth: $selectedMonth)
                Spacer()
            }
            .searchable(
                text: $searchText,  // Binding to search text for filtering recipes
                placement: .navigationBarDrawer(displayMode: .always),  // Place search bar in the navigation bar
                prompt: "Suche nach Rezepten"  // Search placeholder text
            )
            .navigationTitle("Rezepte")  // Title of the view
            .toolbar {
                // Dark mode toggle button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isDarkModeEnabled.toggle()  // Toggle dark mode state
                    } label: {
                        // Use different system icons based on dark mode state
                        Image(
                            systemName: isDarkModeEnabled
                                ? "moon.stars.fill" : "sun.max.fill"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(
                            isDarkModeEnabled ? .white : Color(.systemYellow)
                        )
                        .shadow(
                            color: isDarkModeEnabled
                                ? Color.white
                                : Color(.systemYellow), radius: 5,
                            x: 0, y: 0)
                    }
                    .onChange(of: isDarkModeEnabled) { _, _ in
                        // Update the appearance based on dark mode setting
                        updateAppearance()
                    }
                }

                // Button to toggle filter visibility
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(
                            .spring(
                                response: 0.5, dampingFraction: 0.7,
                                blendDuration: 0.5)
                        ) {
                            showFilters.toggle()  // Toggle the visibility of filter options
                        }
                    } label: {
                        // Icon to indicate whether filters are shown or hidden
                        Image(
                            systemName: showFilters
                                ? "line.3.horizontal.decrease.circle.fill"
                                : "line.3.horizontal.decrease.circle"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(Color(.systemOrange))
                        .shadow(
                            color: Color(.systemOrange), radius: 5,
                            x: 0, y: 0)
                    }
                }

                // Button to toggle favorite filter
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedRecipeIsFavorite.toggle()  // Toggle favorite filter
                    } label: {
                        // Icon to indicate whether 'favorite' filter is active
                        Image(
                            systemName: selectedRecipeIsFavorite
                                ? "heart.fill" : "heart.slash.fill"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(
                            selectedRecipeIsFavorite
                                ? Color(.systemPink) : Color(.systemPink)
                        )
                        .shadow(
                            color: Color(.systemPink), radius: 5,
                            x: 0, y: 0)
                    }
                }
            }
        }
    }

    // Update the application's appearance to match the dark/light mode setting
    private func updateAppearance() {
        // Update UIKit interface style for compatibility with the dark mode toggle
        let windowScene =
            UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.overrideUserInterfaceStyle =
            isDarkModeEnabled ? .dark : .light
    }
}
