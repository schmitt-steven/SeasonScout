//
//  RecipeInfoView.swift
//  ios-project
//
//  Created by Poimandres on 03.11.24.
//

import SwiftUI

struct RecipeInfoView: View {
    
    let recipe: Recipe
    
    var body: some View {
        Text("\(recipe.title)")
    }
}

#Preview {
    var recipe = Recipe.recipes[99]
    RecipeInfoView(recipe: recipe)
}
