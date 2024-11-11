import Foundation

struct JsonParser {
    static func parseToProducts(fileName: String) -> [Product] {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("File couldn't be found")
            return []
        }

        guard let data = try? Data(contentsOf: fileURL) else {
            print("File couldn't be opened")
            return []
        }

        do {
            let rawProducts = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            var products: [Product] = []
            
            for rawProduct in rawProducts ?? [] {
                // Directly extract and cast values
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

                // Decode type and subtype from strings to enums
                guard let type = ProductType(rawValue: typeString) else {
                    print("Warning: Unknown product type '\(typeString)' found in JSON.")
                    continue // Skip this product if type is unknown
                }

                guard let subtype = ProductSubtype(rawValue: subtypeString) else {
                    print("Warning: Unknown product subtype '\(subtypeString)' found in JSON.")
                    continue // Skip this product if subtype is unknown
                }
                
                // Decode seasonalData from strings to enums
                var seasonalData: [Month: [AvailabilityType]] = [:]
                for (monthString, availabilityStrings) in seasonalDataRaw {
                    if let month = Month(rawValue: monthString) {
                        let availability = availabilityStrings.compactMap { AvailabilityType(rawValue: $0) }
                        seasonalData[month] = availability
                    } else {
                        print("Warning: Unknown month string '\(monthString)' found in JSON.")
                    }
                }

                // Create the Product instance
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
            
            return products
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }
}
