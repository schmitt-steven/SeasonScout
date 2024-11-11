
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        VStack {
            TabView(selection: $selectedTab){
                ProductView()
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("Produkt")
                    }
                    .tag(0)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Einstellungen")
                    }
                    .tag(1)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
