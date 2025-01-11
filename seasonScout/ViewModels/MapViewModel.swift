import CoreLocation
import MapKit
import SwiftUI

// A CLLocationManagerDelegate instance is used by the CLLocationManager to report (1.) location changes and (2.) changes in the location authorization status as well as (3.) location related errors
class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {

    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    var onLocationError: ((Error) -> Void)?
    var onPositionChange: ((CLLocation) -> Void)?

    // Tells the delegate that new location data is available.
    // The most recent location update is at the end of the locations array.
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        onPositionChange?(locations.last!)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        onAuthorizationChange?(status)
    }

    func locationManager(
        _ manager: CLLocationManager, didFailWithError error: Error
    ) {
        onLocationError?(error)
    }
}

class MapViewModel: ObservableObject {

    let locationManager: CLLocationManager = CLLocationManager()
    let mapStyleAndIcon: [(MapStyle, Image)] = [
        (MapStyle.standard(elevation: .realistic), Image(systemName: "map")),
        (
            MapStyle.hybrid(elevation: .realistic),
            Image(systemName: "globe.europe.africa")
        ),
        (
            MapStyle.imagery(elevation: .realistic),
            Image(systemName: "globe.europe.africa.fill")
        ),
    ]
    private let locationDelegate: LocationManagerDelegate =
        LocationManagerDelegate()
    private var allSearchResults: [Double: [MKMapItem]] = [:]
    private let minRadius: Double = 5_000.0  // in meters
    private let maxRadius: Double = 50_000.0
    private let stepSize: Double = 5_000.0
    private var searchNotificationTask: Task<Void, Never>? = nil

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
    @Published var shownRoutePolyline: MKPolyline?

    init() {
        self.currentAuthorizationStatus = locationManager.authorizationStatus
        self.locationManager.delegate = self.locationDelegate
        self.locationManager.distanceFilter = 200.0  // specifies distance in horizontal meters to be traveled until a location update event is triggered
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.currentMapStyle = mapStyleAndIcon.first!
        self.locationDelegate.onAuthorizationChange = handleAuthorizationChange(
            status:)
        self.locationDelegate.onPositionChange = handlePositionChange(location:)
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
        let currentIndex = mapStyleAndIcon.firstIndex(where: {
            $0.1 == currentMapStyle.1
        })

        withAnimation {
            currentMapStyle =
                mapStyleAndIcon[(currentIndex! + 1) % mapStyleAndIcon.count]
        }
    }

    private func handlePositionChange(location: CLLocation) {
        self.allSearchResults.removeAll()
        Task {
            await searchForMarkets(using: location)
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
            withAnimation(.easeInOut) {
                self.shownMapItems.removeAll()
                self.isLocationSettingsAlertVisible = true
            }
        default:
            break
        }
    }

    func updateCameraPosition(to coordinate: CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            let span = calculateCoordinateSpan(
                for: self.currentSearchRadiusInMeters)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            withAnimation(.bouncy(duration: 1)) {
                self.mapCameraPosition = .region(region)
            }
        }
    }

    func calculateCoordinateSpan(for radiusInMeters: Double) -> MKCoordinateSpan
    {
        let metersPerDegree = 30_000.0
        // Converts radius in meters to degrees
        let delta = radiusInMeters / metersPerDegree

        return MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
    }

    private func buildMarketSearchRequests(using location: CLLocation)
        -> [MKLocalSearch.Request]
    {
        let totalRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: CLLocationDistance(
                self.currentSearchRadiusInMeters * 2),
            longitudinalMeters: CLLocationDistance(
                self.currentSearchRadiusInMeters * 2)
        )
        // Half the width of the region in longitudinal degrees
        let halfLongitudeDelta = totalRegion.span.longitudeDelta / 2

        // Left region: move region center to the left by half the width
        let leftRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude - halfLongitudeDelta
                    / 2
            ),
            span: MKCoordinateSpan(
                latitudeDelta: totalRegion.span.latitudeDelta,
                longitudeDelta: halfLongitudeDelta
            )
        )

        // Right region: move region center to the right by half the width
        let rightRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude + halfLongitudeDelta
                    / 2
            ),
            span: MKCoordinateSpan(
                latitudeDelta: totalRegion.span.latitudeDelta,
                longitudeDelta: halfLongitudeDelta
            )
        )

        let leftRequest = MKLocalSearch.Request()
        leftRequest.naturalLanguageQuery = "Wochenmarkt"
        leftRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [
            .foodMarket
        ])
        leftRequest.regionPriority = .required
        leftRequest.region = leftRegion

        let rightRequest = MKLocalSearch.Request()
        rightRequest.naturalLanguageQuery = "Wochenmarkt"
        rightRequest.pointOfInterestFilter = MKPointOfInterestFilter(
            including: [.foodMarket])
        rightRequest.regionPriority = .required
        rightRequest.region = rightRegion

        return [leftRequest, rightRequest]
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

        let requests = buildMarketSearchRequests(using: location)
        let requestForLeftSide = requests[0]
        let requestForRightSide = requests[1]

        do {
            let leftSearchTask = Task {
                return try await MKLocalSearch(request: requestForLeftSide)
                    .start()
            }

            let rightSearchTask = Task {
                return try await MKLocalSearch(request: requestForRightSide)
                    .start()
            }

            let leftResponse = try await leftSearchTask.value
            let rightResponse = try await rightSearchTask.value

            let allMapItems = leftResponse.mapItems + rightResponse.mapItems
            // Filter all items based on the selected radius
            let filteredMapItems = filterMapItemsBasedOnRadius(
                userLocation: location, mapItems: allMapItems)

            self.allSearchResults[currentSearchRadiusInMeters] =
                filteredMapItems
            self.updateShownMapItems()

            withAnimation(.easeInOut) {
                self.showSearchResultsNotification()
                self.isMapMarkerVisible = true
            }

        } catch let error as NSError {

            // Handles network errors
            if error.domain == NSURLErrorDomain {
                print(
                    "MapView: A network error occured: \(error.localizedDescription)"
                )

                withAnimation(.easeInOut) {
                    self.isInternetConnectionBad = true
                }

                // Handles any non network related errors
            } else {
                print(
                    "MapView: Market search failed with error: \(error.localizedDescription)"
                )
                withAnimation(.easeInOut) {
                    self.isUnexpectedError = true
                }
            }
        }
    }

    // Filters list of map items to only entries that are inside the specified radius(self.searchRadiusInMeters)
    private func filterMapItemsBasedOnRadius(
        userLocation: CLLocation, mapItems: [MKMapItem]
    ) -> [MKMapItem] {
        let centerLocation = CLLocation(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude)

        let filteredMapItems: [MKMapItem] = mapItems.filter { item in
            guard let itemLocation = item.placemark.location else {
                return false
            }
            // Checks if the map items distance to the users location is smaller than the radius (and returns a bool)
            return centerLocation.distance(from: itemLocation)
                < Double(self.currentSearchRadiusInMeters)
        }

        return filteredMapItems
    }

    func updateShownMapItems() {
        var cumulativeResults: [MKMapItem] = []

        if let currentResults = self.allSearchResults[
            currentSearchRadiusInMeters]
        {
            cumulativeResults = currentResults
        }

        // Look for smaller radii results if necessary
        for radius in stride(
            from: currentSearchRadiusInMeters - stepSize, through: minRadius,
            by: -stepSize)
        {
            if let smallerRadiusResults = self.allSearchResults[radius] {
                for item in smallerRadiusResults {
                    // Filter out duplicates
                    if !cumulativeResults.contains(where: {
                        $0.placemark.coordinate.latitude
                            == item.placemark.coordinate.latitude
                            && $0.placemark.coordinate.longitude
                                == item.placemark.coordinate.longitude
                    }) {
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
