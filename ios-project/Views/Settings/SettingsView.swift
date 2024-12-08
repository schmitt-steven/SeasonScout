import SwiftUI

struct SettingsView: View {
    
    // Persist dark mode preference
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @State private var isNotificationEnabled = false

    var body: some View {
        NavigationView {
            List {
                // Dark Mode Section
                Section(header: Text("Darstellung").font(.headline)) {
                    Toggle(isOn: $isDarkModeEnabled) {
                        Text("Dark Mode aktivieren")
                    }
                    .onChange(of: isDarkModeEnabled) { _ in
                        // Trigger the appearance update
                        updateAppearance()
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                // Notification Section
                Section(header: Text("Benachrichtigungen").font(.headline)) {
                    Toggle(isOn: $isNotificationEnabled) {
                        Text("Push-Benachrichtigung aktivieren")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
            }
            .listStyle(InsetGroupedListStyle()) // iOS Settings-style list
            .navigationBarTitle("Einstellungen", displayMode: .large) // Large navigation title
        }
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light) // Bind SwiftUI environment to the dark mode setting
    }
    
    // Update the application's appearance
    private func updateAppearance() {
        // Update UIKit interface style for compatibility
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
}

// Preview
#Preview {
    SettingsView()
}
