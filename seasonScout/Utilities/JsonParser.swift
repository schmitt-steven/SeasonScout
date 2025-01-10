//
//  JsonParser.swift
//  ios-project
//

import Foundation

// JsonParser struct to handle JSON parsing for Product and Recipe data
struct JsonParser {
    
    // Method to parse JSON data into Product objects
    static func parseToProducts(fileName: String) -> [Product] {
        // Get the file path for the JSON file in the main bundle
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Error: File couldn't be found, returning an empty list..")
            return []
        }

        // Try to read the data from the file
        guard let data = try? Data(contentsOf: filePath) else {
            print("Error: File couldn't be opened, returning an empty list..")
            return []
        }

        do {
            // Deserialize the JSON into a raw array of dictionaries
            let rawProducts = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            var products: [Product] = []

            // Ordered months array for sorting seasonal data
            let orderedMonths: [Month] = [
                .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov, .dec
            ]

            // Parse each product from the raw JSON data
            for rawProduct in rawProducts! {
                let id = rawProduct["id"] as! Int
                let name = rawProduct["name"] as! String
                let botanicalName = rawProduct["botanicalName"] as! String
                let description = rawProduct["description"] as! String
                let storageInstructions = rawProduct["storageInstructions"] as! String
                let energyConsumption = rawProduct["energyConsumption"] as! String
                let isImportedOnly = rawProduct["isImportedOnly"] as! Bool
                let isFavorite = rawProduct["isFavorite"] as! Bool
                let typeString = rawProduct["type"] as! String
                let subtypeString = rawProduct["subtype"] as! String
                let seasonalDataRaw = rawProduct["seasonalData"] as! [String: [String]]
                let imageName = rawProduct["imageName"] as! String
                let imageSource = rawProduct["imageSource"] as! String

                // Validate and parse the product type and subtype enums
                guard let type = ProductType(rawValue: typeString) else {
                    print("Warning: Unknown product type '\(typeString)' found in JSON.")
                    continue // Skip this product if type is unknown
                }
                guard let subtype = ProductSubtype(rawValue: subtypeString) else {
                    print("Warning: Unknown product subtype '\(subtypeString)' found in JSON.")
                    continue // Skip this product if subtype is unknown
                }

                // Convert seasonal data from dictionary to sorted tuple array
                let seasonalDataTuples = seasonalDataRaw.compactMap { (monthString, availabilityStrings) -> (Month, [String])? in
                    if let month = Month(rawValue: monthString) {
                        return (month, availabilityStrings)
                    } else {
                        print("Warning: Unknown month string '\(monthString)' found in JSON.")
                        return nil
                    }
                }

                // Sort the seasonal data by the order of months
                let sortedSeasonalDataTuples = seasonalDataTuples.sorted {
                    guard let firstIndex = orderedMonths.firstIndex(of: $0.0),
                          let secondIndex = orderedMonths.firstIndex(of: $1.0) else {
                        return false // Fallback if month is not found
                    }
                    return firstIndex < secondIndex
                }

                // Create the final seasonal data from sorted tuples
                var seasonalData: [SeasonalData] = []
                for (month, availabilityStrings) in sortedSeasonalDataTuples {
                    let availability = availabilityStrings.compactMap { Availability(rawValue: $0) }
                    seasonalData.append(contentsOf: availability.map { SeasonalData(month: month, availability: $0) })
                }

                // Create the Product object
                let product = Product(
                    id: id,
                    name: name,
                    botanicalName: botanicalName,
                    description: description,
                    storageInstructions: storageInstructions,
                    energyConsumption: energyConsumption,
                    isImportedOnly: isImportedOnly,
                    type: type,
                    subtype: subtype,
                    seasonalData: seasonalData,
                    isFavorite: isFavorite,
                    imageName: imageName,
                    imageSource: imageSource
                )

                products.append(product)
            }
            
            products.shuffle()

            print("Success: loaded \(products.count) products.")
            return products
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }
    
    // Method to parse JSON data into Recipe objects
    static func parseToRecipes(fileName: String) -> [Recipe] {
        // Get the file path for the JSON file in the main bundle
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("Error: File \(fileName) not found, returning an empty recipe list.")
            return []
        }

        do {
            // Read the JSON data from the file
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            guard let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
                print("Error: JSON data is not in a valid format.")
                return []
            }

            var recipes = [Recipe]()

            // Define the ordered months for sorting
            let orderedMonths: [Month] = [
                .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov, .dec
            ]

            // Parse each recipe from the raw JSON data
            for item in jsonArray {
                // Extract and validate the recipe data
                if let id = item["id"] as? Int,
                   let title = item["title"] as? String,
                   let categoryRaw = item["category"] as? String,
                   let effortRaw = item["effort"] as? String,
                   let priceRaw = item["price"] as? String,
                   let isFavorite = item["isFavorite"] as? Bool,
                   let isForGroups = item["isForGroups"] as? Bool,
                   let isVegetarian = item["isVegetarian"] as? Bool,
                   let source = item["source"] as? String,
                   let imageName = item["imageName"] as? String,
                   let description = item["description"] as? String,
                   let instructions = item["instructions"] as? String,
                   let seasonalDataRaw = item["seasonalData"] as? [String: String],
                   let ingredientsByPersonsRaw = item["ingredientsByPersons"] as? [String: [String: String]]
                {
                    // Convert the category, effort, and price strings to their respective enums
                    guard let category = RecipeCategory(rawValue: categoryRaw),
                          let effort = Level(rawValue: effortRaw),
                          let price = Level(rawValue: priceRaw) else {
                        print("Error: Invalid category, effort, or price for recipe '\(title)', (ID: \(id)). Skipping this recipe.")
                        continue
                    }

                    var seasonalData: [RecipeSeasonalMonthData] = []

                    // Sort the seasonalDataRaw by Month order
                    let sortedSeasonalDataRaw = seasonalDataRaw.keys.sorted { (firstKey, secondKey) in
                        guard let firstIndex = orderedMonths.firstIndex(of: Month(rawValue: firstKey) ?? .jan),
                              let secondIndex = orderedMonths.firstIndex(of: Month(rawValue: secondKey) ?? .jan) else {
                                return false // Fallback if for any reason the month is not found
                        }
                        return firstIndex < secondIndex
                    }

                    // Create SeasonalData array
                    for monthString in sortedSeasonalDataRaw {
                        if let month = Month(rawValue: monthString) {
                            let availability = seasonalDataRaw[monthString] ?? ""
                            seasonalData.append(RecipeSeasonalMonthData(month: month, availability: availability))
                        } else {
                            print("Warning: Invalid month \(monthString) in seasonal data for recipe \(title). Skipping.")
                        }
                    }

                    // Convert ingredientsByPersons to correct format
                    var ingredientsByPersons: [PersonsIngredients] = []
                    for (key, ingredients) in ingredientsByPersonsRaw {
                        if let personCount = Int(key) {
                            var ingredientList: [Ingredient] = ingredients.map { Ingredient(name: $0.key, amount: $0.value) }
                            
                            // Sort the ingredientList alphabetically by ingredient name
                            ingredientList.sort { $0.name < $1.name }
                            
                            ingredientsByPersons.append(PersonsIngredients(personNumber: personCount, ingredients: ingredientList))
                        } else {
                            print("Warning: Invalid person count \(key) in ingredients for recipe \(title). Skipping.")
                        }
                    }

                    // Create Recipe object
                    let recipe = Recipe(
                        id: id,
                        title: title,
                        category: category,
                        effort: effort,
                        price: price,
                        isFavorite: isFavorite,
                        isForGroups: isForGroups,
                        isVegetarian: isVegetarian,
                        source: source,
                        imageName: imageName,
                        description: description,
                        instructions: instructions,
                        seasonalData: seasonalData,
                        ingredientsByPersons: ingredientsByPersons
                    )

                    recipes.append(recipe)
                } else {
                    print("Error: Missing or invalid data for recipe \(item["title"] ?? "Unknown Title"). Skipping this recipe.")
                }
                
                recipes.shuffle()

                print("Success: loaded \(recipes.count) recipes.")
                return recipes

            }
            print("Success: loaded \(recipes.count) recipes.")
            return recipes

        } catch {
            print("Error: While parsing recipe JSON: \(error)")
            return []
        }
    }
}
