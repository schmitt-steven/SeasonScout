//
//  LookAroundSceneService.swift
//  ios-project
//
//  Created by Poimandres on 07.12.24.
//
import MapKit

struct RouteData {
    let transportType: MKDirectionsTransportType
    let distance: CLLocationDistance
    let eta: TimeInterval
    let polyline: MKPolyline?
}

struct MapService {
    
    static func getLookAroundScene(mapItem: MKMapItem) async -> MKLookAroundScene? {
        let request = MKLookAroundSceneRequest(mapItem: mapItem)
        if let scene = try? await request.scene {
            return scene
        }
        return nil
    }
    
    static func getRouteAndETA(userCoordinate: CLLocationCoordinate2D, mapItem: MKMapItem, transportType: MKDirectionsTransportType) async -> RouteData? {
        
        let routeRequest = MKDirections.Request()
        routeRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
        routeRequest.destination = mapItem
        routeRequest.transportType = transportType
        routeRequest.departureDate = .now

        do {
            // Mapkit doesnt support polyline for transit :((( Hence the ETA func is used
            if transportType == .transit {
                let etaResponse = try await MKDirections(request: routeRequest).calculateETA()

                return RouteData(
                    transportType: transportType,
                    distance: etaResponse.distance,
                    eta: etaResponse.expectedTravelTime / 60,
                    polyline: nil
                )
            } else {
                let response = try await MKDirections(request: routeRequest).calculate()

                if let route = response.routes.first {
                    return RouteData(
                        transportType: transportType,
                        distance: route.distance,
                        eta: route.expectedTravelTime / 60,
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
