//
//  ProductSubtype.swift
//  ios-project
//


enum ProductSubtype: String, Codable {
    // Vegetable and salad cases
    case fruiting = "Fruchtgemüse"
    case flowering = "Blütengemüse"
    case root = "Wurzelgemüse"
    case leafy = "Blattgemüse"
    case legume = "Hülsenfrüchte"
    
    // Fruit cases
    case core = "Kernobst"
    case stone = "Steinobst"
    case berry = "Beerenobst"
    case shell = "Schalenobst"
    case tropical = "Tropisches Obst"
    
    // Herb cases
    case monokotyledonen = "Monokotyledonen"
    case magnoliopsida = "Magnoliopsida"
    case rosopsida = "Rosopsida"
}
