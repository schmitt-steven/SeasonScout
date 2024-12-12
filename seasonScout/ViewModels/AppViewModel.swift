import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var isLoading: Bool = true // Loading state

    init() {
        simulateAppInitialization()
    }

    private func simulateAppInitialization() {
        // Simulate some initialization (e.g., data fetching)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isLoading = false // Loading complete
        }
    }
}
