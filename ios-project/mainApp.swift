//
//  ios_projectApp.swift
//  ios-project
//
//


import SwiftUI

@main
struct ios_projectApp: App {
    let persistenceController = PersistenceController.shared

    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false

    init() {
        // Load all products and recipes
        Product.products = JsonParser.parseToProducts(fileName: "products")
        Recipe.recipes = JsonParser.parseToRecipes(fileName: "recipes")
        Recipe.recipes.forEach { recipe in
            recipe.isFavorite = recipe.loadFavoriteState(for: recipe.id)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light) // Bind SwiftUI environment to dark mode
        }
    }
}
