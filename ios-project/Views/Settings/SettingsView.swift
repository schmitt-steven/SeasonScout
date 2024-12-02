import SwiftUI

struct SettingsView: View {
    
    // Use @AppStorage to persist the dark mode preference
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @State private var isNotificationEnabled = false

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                // Dark mode toggle
                Toggle(isOn: $isDarkModeEnabled) {
                    Text("Dark-Mode aktivieren")
                    if isDarkModeEnabled {
                        Text("Dark-Mode aktiviert").preferredColorScheme(.dark)
                    }
                }
                .padding(.horizontal)
                .onChange(of: isDarkModeEnabled) { value in
                    // The dark mode is automatically applied by the @AppStorage binding
                }
                
                // Push notification toggle (unchanged)
                Toggle(isOn: $isNotificationEnabled) {
                    Text("Push-Benachrichtigung aktivieren")
                }
                .padding(.horizontal)
            }
        }
    }
}
