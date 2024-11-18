//
//  ContentView.swift
//  ios-project
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
        var body: some View {
            VStack {
                TabView(selection: $selectedTab) {
                    MapView().tabItem {
                        Image(systemName: "map.fill")
                        Text("Karte")
                    }.tag(0)
                    
                    CalendarView().tabItem {
                        Image(systemName: "calendar")
                        Text("Kalender")
                    }.tag(1)
                    
                    RecipesView().tabItem {
                        Image(systemName: "book.fill")
                        Text("Rezepte")
                    }.tag(2)
                }
            }
            //.padding()
        }
}

#Preview {
    ContentView()
}
