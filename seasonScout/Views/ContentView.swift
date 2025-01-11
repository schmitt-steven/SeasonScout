import SwiftUI

/// The main content view that shows a tab bar for navigation.
struct ContentView: View {
    // State variable to toggle the dark mode
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    // State variable to track the selected tab
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
