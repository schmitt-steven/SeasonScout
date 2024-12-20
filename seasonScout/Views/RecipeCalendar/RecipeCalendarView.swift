//
//  RecipeCalenderView.swift
//  ios-project
//
//  Created by Henry Harder on 16.11.24.
//

import SwiftUI

struct RecipeCalendarView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @State private var searchText = ""
    @State private var selectedMonth = Month.allCases[
        Calendar.current.component(.month, from: Date()) - 1]
    @State private var excludeNotRegionallyRecipes = true
    @State private var showFilters = false
    @State private var selectedRecipeCategory: RecipeCategory? = nil
    @State private var selectedRecipeEffort: Level? = nil
    @State private var selectedRecipePrice: Level? = nil
    @State private var selectedRecipeIsFavorite = false
    @State private var selectedRecipeIsForGroups = false
    @State private var selectedRecipeIsVegetarian = false

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
                if !selectedRecipeIsFavorite {
                    MonthSelectionView(selectedMonth: $selectedMonth)
                }

                RecipeListView(
                    recipes: filteredRecipes, selectedMonth: selectedMonth)
                Spacer()
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Suche nach Rezepten"
            )
            .navigationTitle("Rezepte")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isDarkModeEnabled.toggle()
                    } label: {
                        Image(
                            systemName: isDarkModeEnabled
                                ? "moon.stars.fill" : "sun.max.fill"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(
                            isDarkModeEnabled ? .white : Color(.systemYellow))
                    }
                    .onChange(of: isDarkModeEnabled) { _, _ in
                        // Trigger the appearance update
                        updateAppearance()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(
                        destination: RecipeFilterView(
                            selectedRecipeCategory: $selectedRecipeCategory,
                            selectedRecipeEffort: $selectedRecipeEffort,
                            selectedRecipePrice: $selectedRecipePrice,
                            selectedRecipeIsForGroups:
                                $selectedRecipeIsForGroups,
                            selectedRecipeIsVegetarian:
                                $selectedRecipeIsVegetarian)
                    ) {
                        Image(
                            systemName: showFilters
                                ? "line.3.horizontal.decrease.circle.fill"
                                : "line.3.horizontal.decrease.circle"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(Color(.systemOrange))
                        .shadow(
                            color: Color(.systemOrange), radius: 10,
                            x: 0, y: 0)

                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedRecipeIsFavorite.toggle()
                    } label: {
                        Image(
                            systemName: selectedRecipeIsFavorite
                                ? "heart.fill" : "heart.slash.fill"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(
                            selectedRecipeIsFavorite
                                ? Color(.systemPink) : Color(.systemPink))
                    }
                }
            }
        }
    }

    // Update the application's appearance
    private func updateAppearance() {
        // Update UIKit interface style for compatibility
        let windowScene =
            UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.overrideUserInterfaceStyle =
            isDarkModeEnabled ? .dark : .light
    }
}
