//
//  MapViewController.swift
//  ios-project
//
//  Created by Poimandres on 01.12.24.
//
import SwiftUI
import CoreLocation
import MapKit


// A CLLocationManagerDelegate instance is used by the CLLocationManager to report changes in the location authorization status
class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    var onLocationError: ((CLError) -> Void)?
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        onAuthorizationChange?(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            onLocationError?(clError)
        } else {
            print("MapView: Unknown error: \(error.localizedDescription)")
        }
    }
}

class MapViewModel: ObservableObject {
    
    let locationManager: CLLocationManager
    private let locationDelegate: LocationManagerDelegate
    private var allSearchResults: [Double: [MKMapItem]] = [:]
    private let minRadius: Double = 5_000.0 // in meters
    private let maxRadius: Double = 50_000.0
    private let stepSize: Double = 5_000.0
    private var searchNotificationTask: Task<Void, Never>? = nil
    let mapStyleAndIcon: [(MapStyle, Image)] = [
        (MapStyle.standard(elevation: .realistic),Image(systemName: "map")),
        (MapStyle.hybrid(elevation: .realistic), Image(systemName: "globe.europe.africa")),
        (MapStyle.imagery(elevation: .realistic), Image(systemName: "globe.europe.africa.fill"))
    ]
    
    @Published var shownMapItems: [MKMapItem] = []
    @Published var currentAuthorizationStatus: CLAuthorizationStatus
    @Published var mapCameraPosition: MapCameraPosition = .automatic
    @Published var isLocationSettingsAlertVisible: Bool = false
    @Published var isInternetConnectionBad: Bool = false
    @Published var isUnexpectedError: Bool = false
    @Published var currentSearchRadiusInMeters: Double = 10_000.0
    @Published var isSearchRadiusBeingEdited: Bool = false
    @Published var isRadiusSliderVisible: Bool = false
    @Published var isSearchResultsNotificationVisible: Bool = false
    @Published var isMapMarkerVisible: Bool = false
    @Published var currentMapStyle: (MapStyle, Image)
    @Published var selectedMapItem: MKMapItem?
    @Published var isMarketDetailSheetVisible: Bool = false
    @Published var routePolyline: MKPolyline? 
    
    init() {
        self.locationManager = CLLocationManager()
        self.locationDelegate = LocationManagerDelegate()
        self.currentAuthorizationStatus = locationManager.authorizationStatus
        self.locationManager.delegate = self.locationDelegate
        self.locationManager.distanceFilter = 100.0
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.currentMapStyle = mapStyleAndIcon.first!
        
        self.locationDelegate.onAuthorizationChange = { [weak self] status in
            DispatchQueue.main.async {
                self?.handleAuthorizationChange(status: status)
            }
        }
        
        self.locationDelegate.onLocationError = { error in
            print("MapView: Location error: \(error.localizedDescription)")
        }
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func changeMapStyle() {
        let currentIndex = mapStyleAndIcon.firstIndex(where: {$0.1 == currentMapStyle.1})
        
        withAnimation(){
            currentMapStyle = mapStyleAndIcon[(currentIndex! + 1) % mapStyleAndIcon.count]
        }
    }
    
    private func handleAuthorizationChange(status: CLAuthorizationStatus) {
        self.currentAuthorizationStatus = status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("MapView: Location services authorized. Starting updates.")
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                updateCameraPosition(to: location.coordinate)
                Task {
                    await searchForMarkets(using: location)
                }
            }
        case .denied:
            print("MapView: Location access is denied.")
            locationManager.stopUpdatingLocation()
            withAnimation(.easeInOut){
                self.isLocationSettingsAlertVisible = true
            }
        default:
            break
        }
    }
    
    func updateCameraPosition(to coordinate: CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            let span = calculateCoordinateSpan(for: self.currentSearchRadiusInMeters)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            withAnimation(.smooth) {
                self.mapCameraPosition = .region(region)
            }
        }
    }
    
    func calculateCoordinateSpan(for radiusInMeters: Double) -> MKCoordinateSpan {
        let metersPerDegree = 30_000.0
        // Converts radius in meters to degrees
        let delta = radiusInMeters / metersPerDegree
        
        return MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
    }
    
    private func buildMarketSearchRequest(using location: CLLocation) -> MKLocalSearch.Request {
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = "Wochenmarkt"
        
        // Whitelisted points of interested; only markets are relevant, rest is excluded
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.foodMarket])
        
        // With .required, search results must be in specified region
        request.regionPriority = .required
        
        // Uses user's location to define the center of the search region and the radius to define the width and height of the region
        // A MKCoordinateRegion is always rectangular, NOT circular
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: CLLocationDistance(self.currentSearchRadiusInMeters * 2),
            longitudinalMeters: CLLocationDistance(self.currentSearchRadiusInMeters * 2)
        )
        return request
    }
    
    // Uses MainActor, since UI bound properties (marketsFoundInUserRegion, isInternetConnectionBad) must be updated from the main thread. Secondly, it solves data race related issues
    @MainActor
    func searchForMarkets(using location: CLLocation? = nil) async {
        
        // Return early if no valid location is provided
        guard let location = location else {
            print("MapView: No valid location provided. Search aborted.")
            return
        }
        
        // Reset search errors for new try
        self.isInternetConnectionBad = false
        self.isUnexpectedError = false
        
        // If results for radius already exist, only update shown map items
        guard self.allSearchResults[currentSearchRadiusInMeters] == nil else {
            self.updateShownMapItems()
            self.showSearchResultsNotification()
            self.isMapMarkerVisible = true
            return
        }
        
        let request = buildMarketSearchRequest(using: location)
        
        do {
            // The search is performed asynchronously and can crash
            let searchResponse: MKLocalSearch.Response = try await MKLocalSearch(request: request).start()
            
            let filteredMarkets = filterMapItemsBasedOnRadius(userLocation: location, mapItems: searchResponse.mapItems)
            
            self.allSearchResults[currentSearchRadiusInMeters] = filteredMarkets
            self.updateShownMapItems()
            
            withAnimation(.easeInOut){
                self.showSearchResultsNotification()
                self.isMapMarkerVisible = true
            }
            
        } catch let error as NSError{
            
            // Handles network errors
            if error.domain == NSURLErrorDomain {
                print("MapView: A network error occured: \(error.localizedDescription)")
                
                withAnimation(.easeInOut){
                    self.isInternetConnectionBad = true
                }
                
                // Handles any non network related errors
            } else {
                print("MapView: Market search failed with error: \(error.localizedDescription)")
                withAnimation(.easeInOut){
                    self.isUnexpectedError = true
                }
            }
        }
    }
    
    // Filters list of map items to only entries that are inside the specified radius(self.searchRadiusInMeters)
    private func filterMapItemsBasedOnRadius(userLocation: CLLocation, mapItems: [MKMapItem]) -> [MKMapItem] {
        let centerLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let filteredMapItems: [MKMapItem] = mapItems.filter { item in
            guard let itemLocation = item.placemark.location else {
                return false
            }
            // Checks if the map items distance to the users location is smaller than the radius (and returns a bool)
            return centerLocation.distance(from: itemLocation) < Double(self.currentSearchRadiusInMeters)
        }
        
        return filteredMapItems
    }
    
    func updateShownMapItems() {
        var cumulativeResults: [MKMapItem] = []
        
        if let currentResults = self.allSearchResults[currentSearchRadiusInMeters] {
            cumulativeResults = currentResults
        }
        
        // Look for smaller radii results if necessary
        for radius in stride(from: currentSearchRadiusInMeters - stepSize, through: minRadius, by: -stepSize) {
            if let smallerRadiusResults = self.allSearchResults[radius] {
                for item in smallerRadiusResults {
                    // Filter out duplicates
                    if !cumulativeResults.contains(where: {$0.placemark.coordinate.latitude == item.placemark.coordinate.latitude && $0.placemark.coordinate.longitude == item.placemark.coordinate.longitude}) {
                        cumulativeResults.append(item)
                    }
                }
                break
            }
        }
        
        // Update the shown map items with the final cumulative results
        self.allSearchResults[currentSearchRadiusInMeters] = cumulativeResults
        self.shownMapItems = cumulativeResults
    }
    
    
    private func showSearchResultsNotification() {
        searchNotificationTask?.cancel()

        searchNotificationTask = Task {
                await updateNotificationVisibility(false)

                // Wait for 100 milliseconds to let the UI update
                try? await Task.sleep(nanoseconds: 100_000_000)
                guard !Task.isCancelled else { return }

                await updateNotificationVisibility(true)

                try? await Task.sleep(nanoseconds: 2_500_000_000)
                guard !Task.isCancelled else { return }

                await updateNotificationVisibility(false)
        }
    }

    @MainActor
    private func updateNotificationVisibility(_ isVisible: Bool) {
        isSearchResultsNotificationVisible = isVisible
    }

}
