import SwiftUI

@main
struct ios_projectApp: App {
    
    init() {
        // Load all products and recipes
        Product.products = JsonParser.parseToProducts(fileName: "products")
        Recipe.recipes = JsonParser.parseToRecipes(fileName: "recipes")
        // Load favorite states for all products and recipes
        Recipe.recipes.forEach { recipe in
            recipe.isFavorite = recipe.getFavoriteState()
        }
        Product.products.forEach { product in
            product.isFavorite = product.getFavoriteState()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
