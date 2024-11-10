//
//  RecipeInfoView.swift
//  ios-project
//

import SwiftUI

struct RecipeInfoView: View {
    
    let recipe: Recipe
    var tagData: [InfoTag] {
        [
            InfoTag(type: .recipeCategory, value: recipe.category.rawValue),
            InfoTag(type: .effortLevel, value: recipe.effort),
            InfoTag(type: .isVegetarian, value: recipe.isVegetarian),
            InfoTag(type: .priceLevel, value: recipe.price),
            InfoTag(type: .forGroups, value: recipe.isForGroups)
        ] }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                RecipeImageCard(recipe: recipe)
                
                RecipeTagsSection(tagDataList: tagData)
                
                RecipeSeasonalityStatus(seasonalData: recipe.seasonalData)
                
                ExpandableTextContainer(title: "Kurzbeschreibung", content: recipe.description)
                
                ExpandableContainer(title: "Zubereitung"){
                    RecipeInstructionsView(instructions: recipe.instructions)
                }

                ExpandableTextContainer(title: "Saisonale Daten", content: "Pie Chart!!!!!")
                
                ExpandableTextContainer(title: "Zutaten", content: "tabelle")
                
                ExpandableTextContainer(title: "Zubereitung", content: recipe.instructions)
                
                
                ExpandableTextContainer(title: "Ähnliche Gerichte", content: "horizontale scroll view")
                
                ExpandableContainer(title: "Saisonales", contentPadding: CGFloat(0)) {
                    RecipePieChart(seasonalData: recipe.sortedSeasonalData)
                }
                                
            }
        }
    }
}

#Preview {
    let recipe = Recipe.recipes[23]
    RecipeInfoView(recipe: recipe)
}
