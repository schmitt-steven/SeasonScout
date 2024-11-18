//
//  SimilarRecipesView.swift
//  ios-project
//
//  Created by Poimandres on 14.11.24.
//

import SwiftUI

struct SimilarRecipesView: View {
    
    let shownRecipe: Recipe
    let recipesOfSameCategory: [Recipe]
    
    init(shownRecipe: Recipe) {
        self.shownRecipe = shownRecipe
        self.recipesOfSameCategory = Recipe.recipes.compactMap { recipe in
            return recipe.category.rawValue == shownRecipe.category.rawValue && recipe.id != shownRecipe.id ? recipe : nil
        }
    }
    
    var body: some View {
        
        ScrollView(.horizontal) {
            
            LazyHStack(spacing: 10) {
                
                ForEach(recipesOfSameCategory, id: \.id) { recipe in
                    
                    Button(action: {
                        // TODO: 
                    }){
                        ZStack(alignment: .bottom) {
                            
                            Image(uiImage: UIImage(named: recipe.imageName)!)
                                .resizable()
                                .scaledToFit()
                                .saturation(1.3)
                                .brightness(0.07)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(radius: 10)
                                .scrollTransition(axis: .horizontal) { content, phase in
                                    content
                                        .rotationEffect(.degrees(phase.value * 1.5))
                                }
                            
                            HStack {
                                Text(recipe.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .modifier(TextShadowEffect())
                                    .modifier(GlowEffect())
                                    .modifier(InnerShadowEffect())
                                    .padding(15)
                                Spacer()
                            }
                            
                        }
                    }
                }
                .containerRelativeFrame(.horizontal)
            }
            .scrollTargetLayout()
        }
        .scrollClipDisabled()
        .contentMargins([.horizontal, .bottom], 20, for: .scrollContent)
        .contentMargins(.top, 5, for: .scrollContent)
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    let rec = Recipe.recipes[13]
    SimilarRecipesView(shownRecipe: rec)
}