struct BadInternetConnectionMessage: View {
    
    @ObservedObject var mapViewController: MapViewController
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.title)
                        .foregroundStyle(.orange)
                    
                    Text("Eine Internetverbindung konnte leider nicht hergestellt werden.")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    Task {
                        if let currentLocation = mapViewController.locationManager.location {
                            await mapViewController.searchForMarkets(using: currentLocation)
                        }
                    }
                }) {
                    Text("Erneut versuchen")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            Spacer()
        }
        .padding(10)
    }
}