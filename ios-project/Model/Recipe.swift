//
//  Recipe.swift
//  ios-project
//
import SwiftUI

class Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
    
    internal init(name: String, amount: String) {
        self.name = name
        self.amount = amount
    }
}

class RecipeSeasonalMonthData: Identifiable{
    let id = UUID()
    let month: Month
    let availability: String
    
    internal init(month: Month, availability: String) {
        self.month = month
        self.availability = availability
    }
  
}

class PersonsIngredients: Identifiable {
    let id = UUID()
    let personNumber: Int
    let ingredients: [Ingredient]
    
    internal init(personNumber: Int, ingredients: [Ingredient]) {
        self.personNumber = personNumber
        self.ingredients = ingredients
    }
}

class Recipe: Identifiable, ObservableObject {

    static var recipes: [Recipe] = []
    
    let id: Int
    let title: String
    let category: RecipeCategory
    let effort: Level
    let price: Level
    
    @Published var isFavorite: Bool
    let isForGroups: Bool
    let isVegetarian: Bool
    
    let source: String
    let imageName: String
    let description: String
    let instructions: String
    
    let seasonalData: [RecipeSeasonalMonthData]
    let ingredientsByPersons: [PersonsIngredients]
    
    internal init(id: Int, title: String, category: RecipeCategory, effort: Level, price: Level, isFavorite: Bool, isForGroups: Bool, isVegetarian: Bool, source: String, imageName: String, description: String, instructions: String, seasonalData: [RecipeSeasonalMonthData], ingredientsByPersons: [PersonsIngredients]){
        self.id = id
        self.title = title
        self.category = category
        self.effort = effort
        self.price = price
        self.isFavorite = isFavorite
        self.isForGroups = isForGroups
        self.isVegetarian = isVegetarian
        self.source = source
        self.imageName = imageName
        self.description = description
        self.instructions = instructions
        self.seasonalData = seasonalData
        self.ingredientsByPersons = ingredientsByPersons
    }
    
    func saveFavoriteState(for recipeID: Int, isFavorite: Bool) {
        UserDefaults.standard.set(isFavorite, forKey: "recipe_\(recipeID)_isFavorite")
    }

    func loadFavoriteState(for recipeID: Int) -> Bool {
        return UserDefaults.standard.bool(forKey: "recipe_\(recipeID)_isFavorite")
    }
    
    func toString() -> String {
        return ("""
            Recipe ID: \(id)
            Title: \(title)
            First Month Data: \(seasonalData[0].month.rawValue), \(seasonalData[0].availability)
            Category: \(category.rawValue)
            Effort: \(effort.rawValue)
            Price: \(price.rawValue)
            Favorite: \(isFavorite)
            For Groups: \(isForGroups)
            Vegetarian: \(isVegetarian)
            Source: \(source)
            Image Name: \(imageName)\n
            Description: \(description)\n
            Instructions: \(instructions)\n
            """)
    }
    
}
