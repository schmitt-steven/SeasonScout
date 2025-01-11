import SwiftUI

/// A view that displays a notification banner showing the number of search results.
/// If no results are found, it displays a "No results" message with an appropriate icon.
struct SearchResultsNotification: View {
    let viewController: MapViewModel
    // Computed property to check if the market list is empty
    var isMarketListEmpty: Bool {
        viewController.shownMapItems.count == 0
    }

    var body: some View {
        VStack {
            HStack {
                // Display an icon based on whether the market list is empty
                Image(
                    systemName: isMarketListEmpty
                        ? "exclamationmark.circle" : "checkmark.circle"
                )
                .foregroundStyle(.orange)
                // Display a message based on the number of search results
                Text(
                    isMarketListEmpty
                        ? "Keine Ergebnisse"
                        : "\(viewController.shownMapItems.count) \(viewController.shownMapItems.count == 1 ? "Ergebnis" : "Ergebnisse")"
                )

            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thickMaterial)
                    .shadow(radius: 6)
            )
            Spacer()  // Push the notification to the top of the VStack
        }

    }
}
