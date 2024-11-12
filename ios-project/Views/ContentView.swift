//
//  ContentView.swift
//  ios-project
//
//

import SwiftUI
import CoreData


struct ContentView: View {
        
    var body: some View {
        Text("hi")
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
