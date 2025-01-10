//
//  MapService.swift
//  ios-project
//
//  Created by Poimandres on 07.12.24.
//

import MapKit

// Represents data related to a route including transport type, distance, ETA, and polyline
struct RouteData {
    let transportType: MKDirectionsTransportType
    let distance: CLLocationDistance
    let eta: TimeInterval
    let polyline: MKPolyline?
}

// Provides map-related services like route calculation and LookAround scenes
struct MapService {
    
    // Fetches a LookAround scene for a given map item (location)
    static func getLookAroundScene(mapItem: MKMapItem) async -> MKLookAroundScene? {
        let request = MKLookAroundSceneRequest(mapItem: mapItem)
        if let scene = try? await request.scene {
            return scene
        }
        return nil
    }
    
    // Calculates the route and estimated time of arrival (ETA) for the user to a destination
    static func getRouteAndETA(userCoordinate: CLLocationCoordinate2D, mapItem: MKMapItem, transportType: MKDirectionsTransportType) async -> RouteData? {
        
        let routeRequest = MKDirections.Request()
        routeRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
        routeRequest.destination = mapItem
        routeRequest.transportType = transportType
        routeRequest.departureDate = .now

        do {
            // For transit, ETA is used since polyline is not available
            if transportType == .transit {
                let etaResponse = try await MKDirections(request: routeRequest).calculateETA()

                return RouteData(
                    transportType: transportType,
                    distance: etaResponse.distance,
                    eta: etaResponse.expectedTravelTime / 60, // ETA in minutes
                    polyline: nil
                )
            } else {
                // For non-transit, polyline and other data are available
                let response = try await MKDirections(request: routeRequest).calculate()

                if let route = response.routes.first {
                    return RouteData(
                        transportType: transportType,
                        distance: route.distance,
                        eta: route.expectedTravelTime / 60, // ETA in minutes
                        polyline: route.polyline
                    )
                }
            }
            return nil
        } catch {
            return nil
        }
    }
}
