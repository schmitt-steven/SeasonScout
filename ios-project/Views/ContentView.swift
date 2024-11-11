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
        VStack {
            Text("Produkte \(allProducts.count)")
            Text(allProducts[44].name)
            Text(allProducts[44].botanicalName)
            Text(allProducts[44].type.rawValue)
            Text(allProducts[44].subtype.rawValue)
            ForEach(allProducts[44].seasonalData.keys.map { $0 }, id: \.self) { month in
                            let availability = allProducts[44].seasonalData[month] ?? []
                            let availabilityText = availability.map { $0.rawValue }.joined(separator: ", ")
                            Text("\(month.rawValue): \(availabilityText)")
                        }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
