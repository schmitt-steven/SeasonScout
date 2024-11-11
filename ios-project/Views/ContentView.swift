//
//  ContentView.swift
//  ios-project
//
//

import SwiftUI
import CoreData


struct ContentView: View {
        
    var body: some View {
        let allProducts = Product.products
        Text("hi")
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
