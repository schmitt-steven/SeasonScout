//
//  MarketDetailSheetHelpers.swift
//  SeasonScout
//
//  Created by Poimandres on 14.12.24.
//

import SwiftUI
import MapKit

extension MarketDetailSheet {
    
    func initializeRoutes() async {
        routes = []
        
        isFetchingRoute = true
        Task {
            let routeAndPolyline = await MapService.getRouteAndETA(
                userCoordinate: self.userCoordinate,
                mapItem: self.mapItem,
                transportType: self.defaultTransportType
            )
            isFetchingRoute = false
            
            if let route = routeAndPolyline {
                withAnimation {
                    selectedRoute = route
                    routes.append(route)
                    
                    mapViewModel.routePolyline = route.polyline
                }
            }
        }

    }
    
    
    func updateRouteInformation(mode: TravelMode) {
        if let route = routes.first(where: { $0.transportType == mode.transportType }) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isHighlighted = true
                selectedRoute = route
                mapViewModel.routePolyline = route.polyline
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.5)){
                        isHighlighted = false
                    }
                }
            }
        } else {
            isFetchingRoute = true

            Task {
                let route = await MapService.getRouteAndETA(
                    userCoordinate: userCoordinate,
                    mapItem: mapItem,
                    transportType: mode.transportType
                )
                
                if let route = route {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        routes.append(route)
                        selectedRoute = route
                        mapViewModel.routePolyline = route.polyline

                        isFetchingRoute = false
                        isHighlighted = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.5)){
                                isHighlighted = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func highlightRoute() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isHighlighted = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isHighlighted = false
            }
        }
    }

    
    func formatDistance(_ distance: Double) -> String {
        if distance >= 1000 {
            let kilometers = distance / 1000
            return String(format: "%.1fkm", kilometers)
        } else {
            return String(format: "%.0fm", distance)
        }
    }

    
    func composeAddress() -> String {
        var components: [String] = []
        
        if var street = mapItem.placemark.thoroughfare {
            if let streetNumber = mapItem.placemark.subThoroughfare {
                street += " \(streetNumber)"
            }
            components.append(street)
        }
        
        if let postalCode = mapItem.placemark.postalCode,
           let city = mapItem.placemark.locality {
            components.append("\(postalCode) \(city)")
        } else if let city = mapItem.placemark.locality {
            components.append(city)
        }
        
        return components.joined(separator: ", ")
    }
    
    
    func formatTime(minutes: Double?) -> String {
        guard let minutes = minutes else { return "" }
        if minutes < 60 {
            return String(format: "%.0f Minuten", minutes)
        } else {
            let hours = Int(minutes) / 60
            let remainingMinutes = Int(minutes) % 60
            if remainingMinutes > 0 {
                return "\(hours)h \(remainingMinutes)min"
            } else {
                return "\(hours) Stunde\(hours > 1 ? "n" : "")"
            }
        }
    }
    
    
    var websiteLink: String {
            return getURLDomainName(from:  mapItem.url!)
    }
    
    
    func getURLDomainName(from url: URL) -> String {
        let urlString = url.absoluteString
        let regex = try! NSRegularExpression(pattern: "https?://(?:www\\.)?([^/]+)(/.*)?")
        let range = NSRange(urlString.startIndex..<urlString.endIndex, in: urlString)
        
        return regex.firstMatch(in: urlString, options: [], range: range)
            .flatMap { Range($0.range(at: 1), in: urlString).map { String(urlString[$0]) } }
        ?? "zur Webseite"
    }
    
    
    func openInMaps() {
        mapItem.openInMaps(launchOptions: nil)
    }
    
        
    func openInMapsWithDirections() {
       
        let launchOptions: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
        ]
      
        MKMapItem.openMaps(with: [mapItem], launchOptions: launchOptions)
    }
    
}