//
//  Product.swift
//  ios-project
//

struct Product: Codable {
    
    static var products: [Product] = []
    
    let id: Int
    let name: String
    let botanicalName: String
    let description: String
    let storageInstructions: String
    let energyConsumption: String
    let isImportedOnly: Bool
    let type: ProductType
    let subtype: ProductSubtype
    let seasonalData: [Month: [Availability]]
    
    var isFavorite: Bool
    }
