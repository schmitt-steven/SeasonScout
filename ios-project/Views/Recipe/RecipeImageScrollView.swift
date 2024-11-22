//
//  SimilarRecipesView.swift
//  ios-project
//
//  Created by Poimandres on 14.11.24.
//

import SwiftUI

struct RecipeImageScrollView: View {
    
    let recipes: [Recipe]
    
    var body: some View {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(recipes, id: \.id) { recipe in
                        NavigationLink(destination: RecipeInfoView(recipe: recipe, selectedMonth: .jan)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    HStack {
                                        Text(recipe.title).font(.headline)
                                    }
                                }
                            }
                        ) {
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
                        .navigationTitle(Text(""))
                        .buttonStyle(PlainButtonStyle())
                    }
                    .containerRelativeFrame(.horizontal)
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .contentMargins([.horizontal, .bottom], 20, for: .scrollContent)
            .contentMargins(.top, 5, for: .scrollContent)
            .contentMargins([.horizontal], 20, for: .scrollIndicators)
            .scrollTargetBehavior(.paging)
        }
}
