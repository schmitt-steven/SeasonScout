//
//  RecipeListView.swift
//  ios-project
//
//  Created by Henry Harder on 16.11.24.
//

import SwiftUI

struct RecipeListView: View {
    let recipes: [Recipe]
    let selectedMonth: Month

    var body: some View {
        ScrollView {
            if recipes.isEmpty {
                // Anzeige einer Nachricht bei leerer Produktliste
                Text("Keine Produkte verfügbar.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(recipes) { recipe in
                        RecipeRowView(recipe: recipe, selectedMonth: selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
    }
}
