//
//  ios_projectApp.swift
//  ios-project
//
//

import SwiftUI

@main
struct ios_projectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
