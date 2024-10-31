//
//  Recipe.swift
//  ios-project
//


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
    
    let seasonalData: [Month: String]
    let ingredientsByPersons: [Int: [String: String]] // [NumOfPersons: [Ingredient: Quantity]]
    
    func toString() -> String {
        let seasonalDataString = seasonalData.map { "\($0.key.rawValue): \($0.value)" }.joined(separator: ", ")
        let ingredientsString = ingredientsByPersons[1]!.map {"\($0.key): \($0.value)"}.joined(separator: "\n")
        
        return ("""
            Recipe ID: \(id)
            Title: \(title)
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
            Seasonal Data: [\(seasonalDataString)]\n
            Ingredients for one person:\n [\(ingredientsString)]
            """)
    }
    
}
