//
//  ViewTabApp.swift
//  ViewTab
//
//  Created by Nicklas Hoang on 10.11.24.
//

import SwiftUI

@main
struct ViewTabApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
