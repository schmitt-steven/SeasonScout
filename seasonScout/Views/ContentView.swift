//
//  ContentView.swift
//  ios-project
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    @State private var selectedTab = 1
        var body: some View {
            TabView(selection: $selectedTab) {
                MapView().tabItem {
                    Image(systemName: "map.fill")
                    Text("Karte")
                }.tag(0)
                
                CalendarView().tabItem {
                    Image(systemName: "calendar")
                    Text("Kalender")
                }.tag(1)
                
                RecipeCalendarView().tabItem {
                    Image(systemName: "book.fill")
                    Text("Rezepte")
                }.tag(2)
            }
            .accentColor(.orange)
            .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
}

#Preview {
    ContentView()
}
