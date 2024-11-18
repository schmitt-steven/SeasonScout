//
//  Product.swift
//  ios-project
//

import Foundation


struct SeasonalData: Identifiable {
    let id = UUID()
    let month: Month
    let availability: Availability
}

struct Product: Identifiable {
    
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
    let seasonalData: [SeasonalData]
    var isFavorite: Bool
}
