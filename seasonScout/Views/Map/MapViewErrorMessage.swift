import SwiftUI

struct MapViewErrorMessage: View {
    @ObservedObject var mapViewController: MapViewModel // Observing the MapViewModel for changes
    let errorType: MapErrorType // Specifies the type of error to display
    
    // Error message text based on error type
    var errorMessage: String {
        switch errorType {
        case .badInternetConnection:
            "Eine Internetverbindung konnte leider nicht hergestellt werden."
        case .unexpectedError:
            "Während der Suche ist ein Fehler aufgetreten."
        }
    }
    
    // System image symbol for the error type
    var errrorSymbol: String {
        switch errorType {
        case .badInternetConnection:
            "wifi.exclamationmark"
        case .unexpectedError:
           "exclamationmark.circle"
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                // Error message with icon
                HStack(spacing: 12) {
                    Image(systemName: errrorSymbol)
                        .font(.title)
                        .foregroundStyle(.orange)
                    
                    Text(errorMessage)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(.regularMaterial.shadow(.drop(radius: 4)))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                
                // Retry button for reattempting market search
                Button(action: {
                    Task {
                        if let currentLocation = mapViewController.locationManager.location {
                            await mapViewController.searchForMarkets(using: currentLocation)
                        }
                    }
                }) {
                    HStack{
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.accentColor)

                        Text("Erneut versuchen")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.regularMaterial.shadow(.drop(radius: 10)))
                .clipShape(.rect(cornerRadius: 8))

            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
            .shadow(radius: 6)
            
            Spacer() // Push content to the top of the screen
        }
        .padding(10)
    }
}
