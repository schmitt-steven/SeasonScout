//
//  RecipeListView.swift
//  ios-project
//
//  Created by Henry Harder on 16.11.24.
//

import SwiftUI

struct RecipeListView: View {
    let recipes: [Recipe]
    @Binding var selectedMonth: Month

    var body: some View {
        ScrollView {
            if recipes.isEmpty {
                VStack(spacing: 6){
                    Text("Du hast noch keine Rezepte zu Deinen Favoriten hinzugefügt!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Um ein Rezept zu favorisieren, wähle ein Rezept aus und tippe auf das Herz in der oberen rechten Ecke.")
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                .padding([.horizontal, .top, .bottom], 20)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(recipes) { recipe in
                        RecipeRowView(recipe: recipe, selectedMonth: $selectedMonth)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
    }
}
