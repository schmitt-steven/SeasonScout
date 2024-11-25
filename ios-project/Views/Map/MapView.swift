//
//  MapView.swift
//  ios-project
//

import SwiftUI
import MapKit

struct MapManager {
    
    static func searchMarkets(searchText: String, visibleRegion: MKCoordinateRegion?) async -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        if let visibleRegion {
            request.region = visibleRegion
        }
        let searchItems = try? await MKLocalSearch(request: request).start()
        if searchItems == nil {
        }
        
        guard let results = searchItems?.mapItems else {
            print("WARNING: Market search didn't yield any results, returning an empty list..")
            return []
        }
        return results
    }
    
    
}


// Make MKMapItem identifiable so it becomes usable with ForEach
extension MKMapItem: @retroactive Identifiable {
    public var id: UUID {
        UUID()
    }
}


struct MapView: View {
    let locationManager = CLLocationManager()
    let authorizedStatuses: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
    let searchQuery = "Wochenmarkt"
    let defaultRegionCoords = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.489156, longitude: 8.462949), // Mannheim
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    @State var listMarketData: [MKMapItem] = []
    @State var userRegion: CLLocationCoordinate2D?
    @State var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
            ForEach(listMarketData) {
                market in
                Marker(coordinate: market.placemark.coordinate) {
                    Label(market.placemark.name ?? "Unbekannter Markt", systemImage: "storefront").font(.largeTitle.bold())
                }.tint(.gray)
            }
        }
        .onAppear {
            // Check if current authorization status enables GPS, if not, request user
            // to turn them on
            if !authorizedStatuses.contains(locationManager.authorizationStatus) {
                locationManager.requestWhenInUseAuthorization()
            }
            
            // TODO: if authorized, use user location to build region and show nearby markets
            cameraPosition = .region(defaultRegionCoords)
            Task {
                listMarketData = await MapManager.searchMarkets(searchText: searchQuery, visibleRegion: defaultRegionCoords)
            }
        }
    }
    
    
    
}
#Preview {
    MapView()
}
