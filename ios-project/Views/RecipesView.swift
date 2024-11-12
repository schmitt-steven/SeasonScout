import SwiftUI

struct RecipesView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {  // lazy, to only load data that is shown
                    ForEach(Array(Recipe.recipes.enumerated()), id: \.element.id) { index, recipe in
                        if let uiImage = UIImage(named: recipe.imageName) {
                            Image(uiImage: uiImage).resizable().frame(width: 300, height: 200)
                        }
                        NavigationLink(destination: RecipeInfoView(recipe: recipe)) {
                            Text("Index \(index): \(recipe.title)")
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .padding()
            .navigationTitle("Recipes")
        }
    }
}

#Preview {
    RecipesView()
}
