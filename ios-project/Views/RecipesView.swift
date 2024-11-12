//
//  RecipesView.swift
//  ios-project
//

import SwiftUI

struct RecipesView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(Recipe.recipes, id: \.id) { recipe in
                    if let uiImage = UIImage(named: recipe.imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Text(recipe.toString())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                }
            }
            .padding()
        }.padding()
    }
}


#Preview {
    RecipesView()
}
