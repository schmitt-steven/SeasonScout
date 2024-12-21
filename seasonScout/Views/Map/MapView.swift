import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    @StateObject private var viewController = MapViewModel()
    
    var body: some View {
        ZStack {
            Map(
                position: $viewController.mapCameraPosition,
                interactionModes: .all,
                selection: $viewController.selectedMapItem
            ) {
                UserAnnotation() {
                    Image(systemName: "person.circle")
                        .symbolEffect(.breathe.plain)
                        .font(.title2)
                        .foregroundStyle(Color(.systemOrange))
                        .background(Circle().fill(.regularMaterial))
                }
                    .mapOverlayLevel(level: .aboveLabels)
                
                if let userLocation = viewController.locationManager.location?.coordinate {
                    MapCircle(center: userLocation, radius: CLLocationDistance(viewController.currentSearchRadiusInMeters))
                        .foregroundStyle(viewController.isSearchRadiusBeingEdited ? Color(.systemOrange).opacity(0.5) : .secondary.opacity(0.1))
                        .stroke(Color(.systemOrange).opacity(0.9), lineWidth: 2)
                }
                
                if viewController.isMapMarkerVisible {
                    ForEach(viewController.shownMapItems, id: \.identifier) { market in
                        Marker(item: market)
                            .tint(Color(.systemOrange))
                            .tag(market)
                            .mapOverlayLevel(level: .aboveRoads)
                    }
                }
                
                if let polyline = viewController.shownRoutePolyline {
                    MapPolyline(polyline)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .red , .yellow]),
                                startPoint: .topLeading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .foregroundStyle(.black)
                }

            }
            
            .contentMargins(.top, 47)
            
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            
            .mapStyle(viewController.currentMapStyle.0)
            
            .accentColor(Color(.systemOrange))
                        
            .onAppear {
                viewController.requestAuthorization()
                if (viewController.currentAuthorizationStatus == .denied) {
                    viewController.isLocationSettingsAlertVisible = true
                }
            }
            .onChange(of: viewController.currentAuthorizationStatus){
                viewController.requestAuthorization()
            }
            .onChange(of: viewController.selectedMapItem){
                viewController.isMarketDetailSheetVisible = true
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
            // Shows additional information when a market was selected on the map
            .sheet(isPresented: Binding<Bool>(
                get: { viewController.selectedMapItem != nil },
                set: { _ in withAnimation(.easeOut){ viewController.selectedMapItem = nil }}
            )) {
                if let mapItem: MKMapItem = viewController.selectedMapItem,
                   let userCoordinate: CLLocationCoordinate2D = viewController.locationManager.location?.coordinate {
                    ScrollView{
                        MarketDetailSheet(mapViewModel: self.viewController,mapItem: mapItem, userCoordinate: userCoordinate)
                    }
                    .presentationBackground(.clear)
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                    .presentationDetents([.fraction(0.27),.fraction(0.57)])
                    .presentationCornerRadius(16)
                    .presentationBackgroundInteraction(.enabled)
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
            
            MapStyleButton(viewModel: viewController)

            // Only show radius slider if searching for markets works
            if(!viewController.isInternetConnectionBad  &&
               [CLAuthorizationStatus.authorizedAlways,
                CLAuthorizationStatus.authorizedWhenInUse].contains(
                    viewController.currentAuthorizationStatus)
            ){
                RadiusSlider(mapViewController: viewController)
            }
            
            // Shows a message AFTER successfully searching for markets with the number of results
            // for a set amount of time only
            if (viewController.isSearchResultsNotificationVisible) {
                SearchResultsNotification(viewController: viewController)
            }

            // Shows a message informing the user about network problems including a retry button
            if (viewController.isInternetConnectionBad) {
                MapViewErrorMessage(mapViewController: viewController, errorType: .badInternetConnection)
            }
            else if (viewController.isUnexpectedError) {
                MapViewErrorMessage(mapViewController: viewController, errorType: .unexpectedError)
            }
            
        }

    }
        
}

#Preview {
    MapView()
}
