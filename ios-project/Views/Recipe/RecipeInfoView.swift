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
        ]
    }
    
    var recipesOfSameCategory: [Recipe] {
        Recipe.recipes.compactMap { otherRecipe in
            return recipe.category.rawValue == otherRecipe.category.rawValue && recipe.id != otherRecipe.id ? otherRecipe : nil
        }
    }
    
    @State var scrollViewOffset: CGFloat = 0
    let startNavbarAnimationOffset: CGFloat = 100
    let endNavBarAnimationOffset: CGFloat = 190
    let animationOffsetRange: CGFloat = 90
    
    
    // calcuates the opacity of the nav bar text (between 0 and 1)
    var titleOpacity: Double {
        switch scrollViewOffset {
        case ..<startNavbarAnimationOffset:
            return 0
        case endNavBarAnimationOffset...:
            return 1
        default:
            return Double((scrollViewOffset - startNavbarAnimationOffset) / animationOffsetRange)
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
                .ignoresSafeArea()
            
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
                        Spacer()
                            .frame(height: 10)
                    }
                }
            
                .ignoresSafeArea(edges: .top)
            
                .scrollIndicators(.hidden)
            
                .onAppear {
                    scrollViewOffset += 0.1  // Simulate scroll (without actually scrolling), to ensure the update logic of the fadeable nav bar is executed when navigating to AND back from a page.
                }
                .scrollViewOffset($scrollViewOffset)
                .navBarOffset($scrollViewOffset, start: startNavbarAnimationOffset, end: endNavBarAnimationOffset)
                .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text(recipe.title)
                                    .font(.title3)
                                Button(action: {
                                    withAnimation{
                                        recipe.isFavorite.toggle()
                                        scrollViewOffset += 0.1  // Trigger updating the custom nav bar view
                                    }
                                    recipe.saveFavoriteState(for: recipe.id, isFavorite: recipe.isFavorite)
                                       }) {
                                           Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                               .font(.headline)
                                               .symbolEffect(
                                                   .bounce,
                                                   value: recipe.isFavorite
                                               )
                                               .foregroundColor(recipe.isFavorite ? .accentColor.opacity(1) : .primary)
                                       }
                            }
                            .opacity(titleOpacity)
                        }
                }
            
            
        }
    }
}

#Preview {
    let recipe = Recipe.recipes[5]
    RecipeInfoView(recipe: recipe, selectedMonth: .nov)
}
