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
    
        var recipesOfSameCategory: [Recipe] {
            Recipe.recipes.compactMap { otherRecipe in
                return recipe.category.rawValue == otherRecipe.category.rawValue && recipe.id != otherRecipe.id ? otherRecipe : nil
            }
        }
    
    var body: some View {        
        ZStack {
            Image(uiImage: UIImage(named: recipe.imageName)!)
                .resizable()
                .scaledToFit()
                .saturation(1.2)
                .hueRotation(.degrees(10))
                .brightness(0.1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            BlurBackgroundView(style: .systemChromeMaterial)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    RecipeImageCard(recipe: recipe)
                    
                    RecipeTagsSection(tagDataList: tagData)
                    
                    RecipeSeasonalityStatus(seasonalData: recipe.seasonalData)
                    
                    ContainerView(title: "Kurzbeschreibung"){ Text(recipe.description)
                    }
                    
                    ExpandableContainerView(title: "Zutatenverfügbarkeit", contentPadding: CGFloat(0)) {
                        RecipePieChart(seasonalData: recipe.seasonalData)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 0)
                    }
                    
                    ExpandableContainerView(title: "Zutaten") {
                        RecipeIngredientTable(ingredientList: recipe.ingredientsByPersons)
                    }
                    
                    ExpandableContainerView(title: "Zubereitung"){
                        RecipeInstructionsView(instructions: recipe.instructions)
                    }
                    
                    ContainerView(title: "Ähnliche Gerichte", contentPadding: CGFloat(0)) {
                        RecipeImageScrollView(recipes: recipesOfSameCategory)
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
    let recipe = Recipe.recipes[5]
    RecipeInfoView(recipe: recipe, selectedMonth: .nov)
}
