//
//  ios_projectApp.swift
//  ios-project
//
//

import SwiftUI

@main
struct ios_projectApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Load all  products
        Product.products = JsonParser.parseToProducts(fileName: "products")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
