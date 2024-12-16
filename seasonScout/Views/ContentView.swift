//
//  ContentView.swift
//  ios-project
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()  // Bind to ViewModel

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

struct LoadingView2: View {
    @State private var appleRotation: Double = -15  // Startposition für den Apfel
    @State private var carrotRotation: Double = 15  // Startposition für die Karotte
    @State private var textOpacity: Double = 0

    var body: some View {
        HStack {
            VStack {
                ZStack {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .offset(x: -20)
                        .rotationEffect(.degrees(appleRotation))
                        .foregroundStyle(
                            MeshGradient(
                                width: 3, height: 3,
                                points: [
                                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                                    .init(0, 0.5), .init(0.5, 0.5),
                                    .init(1, 0.5),
                                    .init(0, 1), .init(0.5, 1), .init(1, 1),
                                ],

                                colors: [
                                    .yellow, .yellow, .green,
                                    .yellow, .green, .yellow,
                                    .green, .green, .yellow,
                                ])
                        )
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2)) {
                                appleRotation = 0  // Zurück zur normalen Ausrichtung
                            }
                        }

                    Image(systemName: "carrot.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .offset(x: 20)
                        .rotationEffect(.degrees(carrotRotation))  // Rotation der Karotte
                        .foregroundStyle(
                            MeshGradient(
                                width: 3, height: 3,
                                points: [
                                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                                    .init(0, 0.5), .init(0.5, 0.5),
                                    .init(1, 0.5),
                                    .init(0, 1), .init(0.5, 1), .init(1, 1),
                                ],
                                colors: [
                                    .orange, .red, .red,
                                    .yellow, .orange, .yellow,
                                    .red, .red, .orange,
                                ])
                        )
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2)) {
                                carrotRotation = 0  // Zurück zur normalen Ausrichtung
                            }
                        }

                }
                Text("SeasonScout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1)) {
                            textOpacity = 1
                        }
                    }
            }
        }
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
