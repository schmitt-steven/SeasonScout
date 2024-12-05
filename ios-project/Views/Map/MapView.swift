import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    @StateObject private var viewController = MapViewModel()
    
    var body: some View {
        ZStack {
            Map(
                position: $viewController.mapCameraPosition,
                selection: $viewController.selectedMarker
            ) {
                UserAnnotation()
                
                if let userLocation = viewController.locationManager.location?.coordinate {
                    MapCircle(center: userLocation, radius: CLLocationDistance(viewController.searchRadiusInMeters))
                        .foregroundStyle(viewController.isSearchRadiusBeingEdited ? Color(.systemOrange).opacity(0.2) : .secondary.opacity(0.2))
                        .stroke(Color(.systemOrange).opacity(0.7), lineWidth: 2)
                }
                
                if viewController.isMapMarkerVisible {
                    ForEach(viewController.marketsFoundInUserRegion, id: \.identifier) { market in
                        Marker(item: market)
                            .tint(Color(.systemOrange))
                            .tag(market)                        
                    }
                }
            }
            .accentColor(Color(.systemOrange))
            .mapStyle(viewController.currentMapStyle)
            
            .onAppear {
                viewController.requestAuthorization()
                if (viewController.currentAuthorizationStatus == .denied) {
                    viewController.isLocationSettingsAlertVisible = true
                }
            }
            .onChange(of: viewController.currentAuthorizationStatus){
                viewController.requestAuthorization()
            }
            .alert(isPresented: $viewController.isLocationSettingsAlertVisible) {
                    Alert(
                        title: Text("GPS-Dienste sind deaktiviert."),
                        message: Text("Um Märkte in deiner Nähe zu sehen, müssen Standortdienste für SeasonScout aktiviert werden."),
                        primaryButton: .default(Text("Einstellungen öffnen")) {
                            viewController.openSettings()
                        },
                        secondaryButton: .cancel(Text("Schließen"))
                    )
            }
            // Shows additional information when a market was slected on the map
            .sheet(isPresented: Binding<Bool>(
                get: { viewController.selectedMarker != nil },
                set: { _ in }
            )) {
                    MarketDetailSheet(mapViewModel: viewController)
                        .presentationDetents([.fraction(0.35) ,.medium])
            }
            
            // Only show radius controls if searching for markets works
            if(!viewController.isInternetConnectionBad &&
               [CLAuthorizationStatus.authorizedAlways,
                CLAuthorizationStatus.authorizedWhenInUse].contains(
                    viewController.currentAuthorizationStatus)
            ){
                RadiusSlider(
                    mapViewController: viewController
                )}

            // Shows a message informing the user about network problems including a retry button
            if (viewController.isInternetConnectionBad) {
                MapViewErrorMessage(mapViewController: viewController, errorType: .badInternetConnection)
            }
            else if (viewController.isUnexpectedError) {
                MapViewErrorMessage(mapViewController: viewController, errorType: .unexpectedError)
            }
            
            // Shows a message AFTER successfully searching for markets with the number of results
            // for a set amount of time only
            if (viewController.isSearchResultsNotificationVisible) {
                SearchResultsNotification(viewController: viewController)
            }
            
        }
    }
        
}

#Preview {
    MapView()
}
