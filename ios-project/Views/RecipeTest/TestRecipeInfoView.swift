//
//  TestRecipeInfoView.swift
//  ios-project
//

import SwiftUI

struct TestRecipeInfoView: View {
    @ObservedObject var recipe: Recipe
    let selectedMonth: Month
    var tagData: [InfoTag] {
        [
            InfoTag(type: .recipeCategory, value: recipe.category.rawValue),
            InfoTag(type: .effortLevel, value: recipe.effort),
            InfoTag(type: .isVegetarian, value: recipe.isVegetarian),
            InfoTag(type: .priceLevel, value: recipe.price),
            InfoTag(type: .forGroups, value: recipe.isForGroups),
        ]
    }
    @State private var isGroupBoxVisible = false
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)

    internal init(recipe: Recipe, selectedMonth: Month) {
        self.recipe = recipe
        self.selectedMonth = selectedMonth
        hapticFeedback.prepare()
    }

    var recipesOfSameCategory: [Recipe] {
        Recipe.recipes.compactMap { otherRecipe in
            return recipe.category.rawValue == otherRecipe.category.rawValue
                && recipe.id != otherRecipe.id ? otherRecipe : nil
        }
    }
    
    @State var scrollViewOffset: CGFloat = 0
    let startNavbarAnimationOffset: CGFloat = 220
    let endNavBarAnimationOffset: CGFloat = 280
    let animationOffsetRange: CGFloat = 60
    
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
        ScrollView {
            TestRecipeImageView(recipe: recipe)
                .ignoresSafeArea()
            ZStack {
                VStack {
                    Text(recipe.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    TestRecipeTagsSection(tagDataList: tagData)

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
                        TestRecipeSeasonalityStatusView(
                            seasonalData: recipe.seasonalData,
                            selectedMonth: selectedMonth
                        )
                        .frame(maxWidth: .infinity)
                    }

                    ExpandableGroupBox(title: "Zutatenverfügbarkeit") {
                        TestRecipePieChart(
                            seasonalData: recipe.seasonalData,
                            selectedMonth: selectedMonth
                        )
                    }

                    ExpandableGroupBox(title: "Zutaten") {
                        RecipeIngredientTable(
                            ingredientList: recipe.ingredientsByPersons)
                    }

                    ExpandableGroupBox(title: "Zubereitung") {
                        TestRecipeInstructionsView(
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

                    InformationSectionView()
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .scrollIndicators(.hidden)
        .onAppear {
            scrollViewOffset += 1
        }
        .navBarOffset($scrollViewOffset, start: startNavbarAnimationOffset, end: endNavBarAnimationOffset)
        .scrollViewOffset($scrollViewOffset)
        .toolbar {
            ToolbarItem(placement: .principal) {
                    Text(recipe.title)
                        .font(.headline)
                        .opacity(titleOpacity)
                        .lineLimit(1)
                        .truncationMode(.tail)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    hapticFeedback.impactOccurred()
                    recipe.isFavorite.toggle()
                    recipe.saveFavoriteState(
                        for: recipe.id, isFavorite: recipe.isFavorite)
                    hapticFeedback.prepare()
                }) {
                    HeartView(isFavorite: recipe.isFavorite)
                }
            }
        }
    }
}

#Preview {
    let recipe = Recipe.recipes[5]
    TestRecipeInfoView(recipe: recipe, selectedMonth: .nov)
}
