//
//  MachtingRecipesView.swift
//  ios-project
//
//  Created by Henry Harder on 23.11.24.
//

import SwiftUI

struct MatchingRecipesView: View {
    let product: Product
    let selectedMonth: Month
    var filteredRecipes: [Recipe] {
        Recipe.recipes.filter { recipe in
            recipe.ingredientsByPersons.flatMap { $0.ingredients }
                .contains { $0.name.contains(product.name) }
        }
    }

    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if filteredRecipes.isEmpty {
                    // Anzeige einer Nachricht bei leerer Rezeptliste
                    Text("Keine Gerichte verfügbar.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink(
                            destination: RecipeInfoView(
                                recipe: recipe, selectedMonth: selectedMonth)
                        ) {
                            GroupBox {
                                VStack {
                                    HStack {
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

                                            Text(recipe.title)
                                                .font(.headline.bold())
                                                .padding(.bottom, 5)
                                                .lineLimit(2)
                                                .truncationMode(.tail)

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
                                    ? 1 : 4,
                                spacing: 16
                            )
                            .scrollTransition { content, phase in
                                return content
                                    .opacity(phase.value == 0 ? 1 : 0.5)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
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
