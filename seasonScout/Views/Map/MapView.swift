import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    @StateObject private var viewController = MapViewModel()
    
    var body: some View {
        ZStack {
            Map(
                position: $viewController.mapCameraPosition,
                selection: $viewController.selectedMapItem
            ) {
                UserAnnotation()
                
                if let userLocation = viewController.locationManager.location?.coordinate {
                    MapCircle(center: userLocation, radius: CLLocationDistance(viewController.currentSearchRadiusInMeters))
                        .foregroundStyle(viewController.isSearchRadiusBeingEdited ? Color(.systemOrange).opacity(0.5) : .secondary.opacity(0.1))
                        .stroke(Color(.systemOrange).opacity(0.8), lineWidth: 1.5)
                }
                
                if viewController.isMapMarkerVisible {
                    ForEach(viewController.shownMapItems, id: \.identifier) { market in
                        Marker(item: market)
                            .tint(Color(.systemOrange))
                            .tag(market)
                    }
                }
                
                if let polyline = viewController.routePolyline {
                    MapPolyline(polyline)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .mint , .yellow]),
                                                    startPoint: .topLeading,
                                                    endPoint: .trailing
                                                ),
                                //Color(.orange).mix(with: .mint, by: 0.2).blendMode(.colorBurn),
                                style: StrokeStyle(
                                    lineWidth: 4,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .foregroundStyle(.black)
                }

            }

            .mapControlVisibility(.visible)
            
            .contentMargins(.top, 45)

            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .accentColor(Color(.systemOrange))
            .mapStyle(viewController.currentMapStyle.0)
            
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
            // Shows additional information when a market was slected on the map
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
            
            // Only show radius controls if searching for markets works
            if(!viewController.isInternetConnectionBad &&
               [CLAuthorizationStatus.authorizedAlways,
                CLAuthorizationStatus.authorizedWhenInUse].contains(
                    viewController.currentAuthorizationStatus)
            ){
                MapStyleButton(viewModel: viewController)
                RadiusSlider(mapViewController: viewController)
            }

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
