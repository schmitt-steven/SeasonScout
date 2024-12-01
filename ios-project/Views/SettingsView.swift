import SwiftUI

struct SettingsView: View {
    
    // Use @AppStorage to persist the dark mode preference
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    @State private var isNotificationEnabled = false

    var body: some View {
        NavigationView {
                    List {
                        // Dark Mode Section
                        Section(header: Text("Darstellung").font(.headline)) {
                            // Dark mode toggle
                            Toggle(isOn: $isDarkModeEnabled) {
                                Text("Dark Mode aktivieren")
                            }
                            .onChange(of: isDarkModeEnabled) { oldValue, newValue in
                                // Automatically updates due to @AppStorage binding
                                updateAppearance()
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        }
                        
                        // Notification Section
                        Section(header: Text("Benachrichtigungen").font(.headline)) {
                            // Push notification toggle
                            Toggle(isOn: $isNotificationEnabled) {
                                Text("Push-Benachrichtigung aktivieren")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        }
                        
                        // You can add more sections as needed
                    }
                    .listStyle(InsetGroupedListStyle()) // iOS Settings-style list
                    .navigationBarTitle("Einstellungen", displayMode: .large) // Large navigation title
                
        }
    }
    
    // Update the application's appearance based on dark mode
    private func updateAppearance() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.keyWindow?.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
}

// Preview
#Preview {
    SettingsView()
}
