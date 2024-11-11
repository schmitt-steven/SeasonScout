//
//  Recipe.swift
//  ios-project
//

import Foundation

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
}

struct RecipeSeasonalMonthData: Identifiable{
    let id = UUID()
    let month: Month
    let availability: String
}

struct Recipe {
    
    static var recipes: [Recipe] = []
    
    let id: Int
    let title: String
    let category: RecipeCategory
    let effort: Level
    let price: Level
    
    let isFavorite: Bool
    let isForGroups: Bool
    let isVegetarian: Bool
    
    let source: String
    let imageName: String
    let description: String
    let instructions: String
    
    let seasonalData: [RecipeSeasonalMonthData]
    let ingredientsByPersons: [Int: [Ingredient]]
    
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
