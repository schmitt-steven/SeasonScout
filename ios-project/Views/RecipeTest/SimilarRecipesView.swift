//
//  SimilarRecipesView.swift
//  ios-project
//
//  Created by Henry Harder on 25.11.24.
//

import SwiftUI

struct SimilarRecipesView: View {
    let recipe: Recipe
    let selectedMonth: Month
    let recipesOfSameCategory: [Recipe]

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(recipe: Recipe, selectedMonth: Month) {
        self.recipe = recipe
        self.selectedMonth = selectedMonth
        self.recipesOfSameCategory = Recipe.recipes.filter { otherRecipe in
            // Prüfen, ob Kategorie gleich und ID unterschiedlich ist
            otherRecipe.category == recipe.category
                && otherRecipe.id != recipe.id
        }
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if recipesOfSameCategory.isEmpty {
                    // Anzeige einer Nachricht bei leerer Rezeptliste
                    GroupBox {
                        Text("Keine Gerichte verfügbar.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    ForEach(recipesOfSameCategory) { otherRecipe in
                        GroupBox {
                            VStack {
                                HStack {
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

                                    VStack(alignment: .leading, spacing: 2) {

                                        Text(otherRecipe.title)
                                            .font(.headline.bold())
                                            .padding(.bottom, 5)
                                            .lineLimit(2)
                                            .truncationMode(.tail)

                                        if let seasonalData =
                                            seasonalDataForSelectedMonth(
                                                recipe: otherRecipe)
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
                                ? 1 : 4,
                            spacing: 16
                        )
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollClipDisabled()
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }

    // Funktion zur Prüfung der Verfügbarkeit des Produkts im aktuellen Monat
    private func seasonalDataForSelectedMonth(recipe: Recipe)
        -> RecipeSeasonalMonthData?
    {
        return recipe.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
