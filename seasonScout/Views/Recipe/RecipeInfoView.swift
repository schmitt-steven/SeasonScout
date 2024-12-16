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
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var recipesOfSameCategory: [Recipe] {
        Recipe.recipes.compactMap { otherRecipe in
            return recipe.category.rawValue == otherRecipe.category.rawValue && recipe.id != otherRecipe.id ? otherRecipe : nil
        }
    }
    
    @State var scrollViewOffset: CGFloat = 0
    let startNavbarAnimationOffset: CGFloat = 200
    let endNavBarAnimationOffset: CGFloat = 260
    let animationOffsetRange: CGFloat = 60
    
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
    
    internal init(recipe: Recipe, selectedMonth: Month, scrollViewOffset: CGFloat = 0) {
        self.recipe = recipe
        self.selectedMonth = selectedMonth
        self.scrollViewOffset = scrollViewOffset
        
        self.hapticFeedback.prepare()
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

                        VStack{
                            Text(recipe.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)

                            RecipeTagsSection(tagDataList: tagData)

                            Text("Kurzbeschreibung")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                                .padding(.top, 25)
                            GroupBox {
                                VStack(alignment: .leading) {
                                    Text(recipe.description)
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity)

                            Text("Verfügbarkeit")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                                .padding(.top, 25)
                            GroupBox {
                                RecipeSeasonalityStatusView(
                                    seasonalData: recipe.seasonalData,
                                    selectedMonth: selectedMonth
                                )
                                .frame(maxWidth: .infinity)
                            }

                            ExpandableGroupBox(title: "Zutatenverfügbarkeit") {
                                RecipePieChart(
                                    seasonalData: recipe.seasonalData,
                                    selectedMonth: selectedMonth
                                )
                            }

                            ExpandableGroupBox(title: "Zutaten") {
                                RecipeIngredientTable(
                                    ingredientList: recipe.ingredientsByPersons)
                            }

                            ExpandableGroupBox(title: "Zubereitung") {
                                RecipeInstructionsView(
                                    instructions: recipe.instructions)
                                    .frame(maxWidth: .infinity)
                            }

                            Text("Ähnliche Gerichte")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                                .padding(.top, 25)
                            SimilarRecipesView(
                                recipe: recipe, selectedMonth: selectedMonth
                            )
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Divider()
                                
                                Text("Informationen zur Seite")
                                    .font(.title3.bold())
                                    .foregroundColor(.gray)
                                Text("Informationen/Bilder stammen von der Webseite \(recipe.source)")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        .padding()
                        Spacer()
                            .frame(height: UINavigationController().navigationBar.frame.height + 50)
                    }
                }
                .toolbar {
                    if self.scrollViewOffset > self.startNavbarAnimationOffset {
                        ToolbarItem(placement: .principal) {
                            Text(recipe.title)
                                .font(.headline)
                                .opacity(titleOpacity)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            hapticFeedback.impactOccurred()
                            hapticFeedback.prepare()
                        }) {
                            RecipeHeartView(recipe: recipe, scale: 1.0)
                        }
                    }
                }

            
                .ignoresSafeArea(edges: .all)
            
                .scrollIndicators(.hidden)
            
                .onAppear {
                    scrollViewOffset += 1  // Simulate scroll (without actually scrolling), to ensure the update logic of the fadeable nav bar is executed when navigating to AND back from a page.
                }
               
                .navBarOffset($scrollViewOffset, start: startNavbarAnimationOffset, end: endNavBarAnimationOffset)
                .scrollViewOffset($scrollViewOffset)
            
        }

    }
}

#Preview {
    let recipe = Recipe.recipes[55]
    RecipeInfoView(recipe: recipe, selectedMonth: .nov)
}
