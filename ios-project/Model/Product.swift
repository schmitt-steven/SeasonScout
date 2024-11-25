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

class Product: Identifiable, ObservableObject {
    
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
    @Published var isFavorite: Bool
    
    internal init(id: Int, name: String, botanicalName: String, description: String, storageInstructions: String, energyConsumption: String, isImportedOnly: Bool, type: ProductType, subtype: ProductSubtype, seasonalData: [SeasonalData], isFavorite: Bool) {
        self.id = id
        self.name = name
        self.botanicalName = botanicalName
        self.description = description
        self.storageInstructions = storageInstructions
        self.energyConsumption = energyConsumption
        self.isImportedOnly = isImportedOnly
        self.type = type
        self.subtype = subtype
        self.seasonalData = seasonalData
        self.isFavorite = isFavorite
    }
    
    func setProductFavorite(for id: Int, isFavorite: Bool) {
        UserDefaults.standard.set(isFavorite, forKey: "product_\(id)_isFavorite")
    }

    func getProductFavorite(for id: Int) -> Bool {
        return UserDefaults.standard.bool(forKey: "product_\(id)_isFavorite")
    }
}
