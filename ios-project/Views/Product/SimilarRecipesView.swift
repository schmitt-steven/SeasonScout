//
//  SimilarRecipesView2.swift
//  ios-project
//
//  Created by Henry Harder on 23.11.24.
//

import SwiftUI

struct SimilarRecipesView: View {
    let product: Product
    let selectedMonth: Month
    var filteredRecipes: [Recipe] {
        Recipe.recipes.filter { recipe in
            recipe.ingredientsByPersons.flatMap { $0.ingredients }
                .contains { $0.name.contains(product.name) }
        }
    }
    
    var body: some View {
        ScrollView {
            if filteredRecipes.isEmpty {
                // Anzeige einer Nachricht bei leerer Rezeptliste
                Text("Keine Rezepte verfügbar.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(filteredRecipes) { otherRecipe in
                        RecipeRowView(recipe: otherRecipe, selectedMonth: selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
        .background(Color.white)
        .navigationTitle("Ähnliche Rezepte")
    }
}
