import Foundation

// Represents seasonal data for a product
struct SeasonalData: Identifiable {
    let id = UUID()
    let month: Month
    let availability: Availability
}

// Represents a product with various properties
class Product: Identifiable, ObservableObject {
    static var products: [Product] = []  // Stores all products

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
    let imageName: String
    let imageSource: String
    @Published var isFavorite: Bool

    // Initializes a new product instance
    internal init(
        id: Int, name: String, botanicalName: String, description: String,
        storageInstructions: String, energyConsumption: String,
        isImportedOnly: Bool, type: ProductType, subtype: ProductSubtype,
        seasonalData: [SeasonalData], isFavorite: Bool, imageName: String,
        imageSource: String
    ) {
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
        self.imageName = imageName
        self.imageSource = imageSource
    }

    func setProductFavorite(isFavorite: Bool) {
        UserDefaults.standard.set(
            isFavorite, forKey: "product_\(self.id)_isFavorite")
    }

    func getFavoriteState() -> Bool {
        return UserDefaults.standard.bool(
            forKey: "product_\(self.id)_isFavorite")
    }
}
