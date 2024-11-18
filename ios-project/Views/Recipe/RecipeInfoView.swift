//
//  RecipeInfoView.swift
//  ios-project
//

import SwiftUI


struct RecipeInfoView: View {
    
    let recipe: Recipe
    let selectedMonth: Month
    var tagData: [InfoTag] {
        [
            InfoTag(type: .recipeCategory, value: recipe.category.rawValue),
            InfoTag(type: .effortLevel, value: recipe.effort),
            InfoTag(type: .isVegetarian, value: recipe.isVegetarian),
            InfoTag(type: .priceLevel, value: recipe.price),
            InfoTag(type: .forGroups, value: recipe.isForGroups)
        ] }
    
    var body: some View {
        
        ZStack {
            Image(uiImage: UIImage(named: recipe.imageName)!)
                .resizable()
                .scaledToFit()
                .saturation(1.2)
                .hueRotation(.degrees(10))
                .brightness(0.1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            BlurView(style: .systemChromeMaterial)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    RecipeImageCard(recipe: recipe)
                    
                    RecipeTagsSection(tagDataList: tagData)
                    
                    RecipeSeasonalityStatus(seasonalData: recipe.seasonalData)
                    
                    ExpandableTextContainer(title: "Kurzbeschreibung", content: recipe.description)
                    
                    ExpandableContainer(title: "Zutatenverfügbarkeit", contentPadding: CGFloat(0)) {
                        RecipePieChart(seasonalData: recipe.seasonalData)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 0)
                    }
                    
                    ExpandableContainer(title: "Zutaten") {
                        RecipeIngredientTable(ingredientList: recipe.ingredientsByPersons)
                    }
                    
                    ExpandableContainer(title: "Zubereitung"){
                        RecipeInstructionsView(instructions: recipe.instructions)
                    }
                    
                    ExpandableContainer(title: "Ähnliche Gerichte", contentPadding: CGFloat(0)) {
                        SimilarRecipesView(shownRecipe: recipe)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    let recipe = Recipe.recipes[5]
    RecipeInfoView(recipe: recipe)
}
