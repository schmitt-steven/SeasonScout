import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    @StateObject private var viewController = MapViewModel()
    
    var body: some View {
        ZStack {
            Map(position: $viewController.mapCameraPosition) {
                UserAnnotation()
                
                if let userLocation = viewController.locationManager.location?.coordinate {
                    MapCircle(center: userLocation, radius: CLLocationDistance(viewController.searchRadiusInMeters))
                        .foregroundStyle(viewController.isSearchRadiusBeingEdited ? .orange.opacity(0.2) : .secondary.opacity(0.1))
                        .stroke(.orange, lineWidth: 2)
                }
                
                if viewController.isMapMarkerVisible {
                    ForEach(viewController.marketsFoundInUserRegion, id: \.identifier) { market in
                        Marker(coordinate: market.placemark.coordinate) {
                            Label(market.placemark.name ?? "Unknown Market", systemImage: "storefront")
                                .font(.largeTitle.bold()
                                )
                        }
                        .tint(.orange)
                    }
                }
            }
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
