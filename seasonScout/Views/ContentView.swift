//
//  ContentView.swift
//  ios-project
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel() // Bind to ViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                MainView()
            }
        }
        .animation(.easeInOut, value: viewModel.isLoading)
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Image("splashscreen")
                    .resizable()
                    .scaledToFit()
            }
        }
        .contentShape(Rectangle())
    }
}

struct MainView: View {
    
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
