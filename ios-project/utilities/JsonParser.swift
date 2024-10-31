import Foundation

struct JsonParser {
    static func parseToProducts(fileName: String) -> [Product] {
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Error: File couldn't be found, returning an empty list..")
            return []
        }

        guard let data = try? Data(contentsOf: filePath) else {
            print("Error: File couldn't be opened, returning an empty list..")
            return []
        }

        do {
            let rawProducts = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            var products: [Product] = []
            
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

                guard let type = ProductType(rawValue: typeString) else {
                    print("Warning: Unknown product type '\(typeString)' found in JSON.")
                    continue // Skip this product if type is unknown
                }
                guard let subtype = ProductSubtype(rawValue: subtypeString) else {
                    print("Warning: Unknown product subtype '\(subtypeString)' found in JSON.")
                    continue // Skip this product if subtype is unknown
                }
                
                // Convert seasonalData from using String to using Month and Availability enum
                var seasonalData: [Month: [Availability]] = [:]
                for (monthString, availabilityStrings) in seasonalDataRaw {
                    if let month = Month(rawValue: monthString) {
                        let availability = availabilityStrings.compactMap { Availability(rawValue: $0) }
                        seasonalData[month] = availability
                    } else {
                        print("Warning: Unknown month string '\(monthString)' found in JSON.")
                    }
                }

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
                    isFavorite: isFavorite
                )
                
                products.append(product)
            }
            
            print("Success: loaded \(products.count) products. ")
            return products
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }
    
    static func parseToRecipes(fileName: String) -> [Recipe] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("Error: File \(fileName) not found, returning an empty recipe list.")
            return []
        }
        
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            guard let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
                print("Error: JSON data is not in a valid format.")
                return []
            }
            
            var recipes = [Recipe]()
            
            for item in jsonArray {
                // Validate and unpack all fields
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
                    // Convert String to Enum
                    guard let category = RecipeCategory(rawValue: categoryRaw),
                          let effort = Level(rawValue: effortRaw),
                          let price = Level(rawValue: priceRaw) else {
                        print("Error: Invalid category, effort, or price for recipe '\(title)', (ID: \(id)). Skipping this recipe.")
                        continue
                    }

                    // Convert seasonalData to use Month enum instead of String
                    var seasonalData = [Month: String]()
                    for (key, value) in seasonalDataRaw {
                        if let month = Month(rawValue: key) {
                            seasonalData[month] = value
                        }
                    }
                    
                    // Convert ingredientsByPersons to use Int instead of String
                    var ingredientsByPersons = [Int: [String: String]]()
                    for (key, value) in ingredientsByPersonsRaw {
                        if let numPersons = Int(key) {
                            ingredientsByPersons[numPersons] = value
                        }
                    }
                    
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
            }
            
            print("Success: loaded \(recipes.count) recipes.")
            return recipes
            
        } catch {
            print("Error: While parsing recipe JSON: \(error)")
            return []
        }
    }


}
