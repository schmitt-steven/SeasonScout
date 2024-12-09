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
    @State private var selectedMonth = Month.allCases[Calendar.current.component(.month, from: Date()) - 1]
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
                MonthSelectionView(selectedMonth: $selectedMonth)
                NavigationLink(destination: RecipeFilterView(
                    selectedRecipeCategory: $selectedRecipeCategory,
                    selectedRecipeEffort: $selectedRecipeEffort,
                    selectedRecipePrice: $selectedRecipePrice,
                    selectedRecipeIsForGroups: $selectedRecipeIsForGroups,
                    selectedRecipeIsVegetarian: $selectedRecipeIsVegetarian
                )) {
                    HStack {
                        Text("Filter anzeigen")
                            .font(.headline)
                            .foregroundColor(isDarkModeEnabled ? .white : .black)

                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundStyle(Color.orange)
                    }

                }
                .padding(.top)
                .padding(.bottom, 2)
                
                Spacer()
                RecipeListView(recipes: filteredRecipes, selectedMonth: selectedMonth)
                Spacer()
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Suche nach Rezepten")
            .navigationTitle("Rezepte")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            excludeNotRegionallyRecipes.toggle()
                        } label: {
                            Label(
                                excludeNotRegionallyRecipes ? "Überregionale Rezepte anzeigen" : "Überregionale Rezepte ausblenden",
                                systemImage: excludeNotRegionallyRecipes ? "ferry" : "leaf"
                            )
                        }
                        Button {
                            selectedRecipeIsFavorite.toggle()
                        } label: {
                            Label(
                                selectedRecipeIsFavorite ? "Favoriten ausblenden" : "Favoriten anzeigen",
                                systemImage: selectedRecipeIsFavorite ? "heart.slash" : "heart"
                            )
                        }
                    } label: {
                        Label("", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }
}