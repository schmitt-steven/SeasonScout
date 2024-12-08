//
//  TravelMode.swift
//  ios-project
//
//  Created by Poimandres on 08.12.24.
//

import SwiftUI
import MapKit

struct MarketDetailSheet: View {

    private let mapItem: MKMapItem
    private var userCoordinate: CLLocationCoordinate2D
    private let defaultTransportType: MKDirectionsTransportType = .automobile
    @State private var selectedRoute: RouteData? = nil
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var routes: [RouteData] = []
    @State private var isFetchingRoute = false
    @State private var isHighlighted = false
    
    internal init(mapItem: MKMapItem, userCoordinate: CLLocationCoordinate2D) {
        self.mapItem = mapItem
        self.userCoordinate = userCoordinate
    }
    
    var body: some View {
        ZStack{
            
            BlurBackgroundView(style: .systemMaterial)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 12) {
                headerSection
                travelTimeSection
                Divider()
                infoSection
                Divider()
                lookAroundSection
                appleMapsButtonSection
                Spacer()
                    .frame(height: 100)
            }
            .background(.clear)
            .padding()
        }
        .task {
                self.lookAroundScene = await MapService.getLookAroundScene(mapItem: self.mapItem)
        }
        .task {
            await initializeRoutes()
        }
        .onChange(of: mapItem) {
            Task {
                await initializeRoutes()
            }
            Task {
                let scene = await MapService.getLookAroundScene(mapItem: self.mapItem)
                withAnimation(.smooth) {
                    self.lookAroundScene = scene
                }
            }
        }
    }
}

extension MarketDetailSheet {
    
    private func initializeRoutes() async {
        routes = []

        if let route = await MapService.getTravelTimeAndDistance(
            userCoordinate: self.userCoordinate,
            mapItem: self.mapItem,
            transportType: self.defaultTransportType
        ) {
            withAnimation {
                selectedRoute = route
                routes.append(route)
            }
        }
    }
    
    private func updateTravelTimeSection(mode: TravelMode) {
        if let route = routes.first(where: { $0.transportType == mode.transportType }) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isHighlighted = true
                selectedRoute = route
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.5)){
                        isHighlighted = false
                    }
                }
            }
        } else {
            isFetchingRoute = true

            Task {
                if let newRoute = await MapService.getTravelTimeAndDistance(
                    userCoordinate: userCoordinate,
                    mapItem: mapItem,
                    transportType: mode.transportType
                ) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        routes.append(newRoute)
                        
                        isFetchingRoute = false
                        isHighlighted = true
                        selectedRoute = newRoute
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
    
    private func formatDistance(_ distance: Double) -> String {
        if distance >= 1000 {
            let kilometers = distance / 1000
            return String(format: "%.1fkm", kilometers)
        } else {
            return String(format: "%.0fm", distance)
        }
    }

    
    private func composeAddress() -> String {
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
    
    private func formatTime(minutes: Double?) -> String {
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
    
    private func openInAppleMaps() {
        mapItem.openInMaps(launchOptions: nil)
    }
    
}



extension MarketDetailSheet {
    
    var travelTimeSection: some View {
        HStack(spacing: 16) {
            ForEach(travelModes, id: \.icon) { mode in
                Button(action: {updateTravelTimeSection(mode: mode)}) {
                    VStack {
                        Image(systemName: "\(mode.icon)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.top, 2)
                        
                        if routes.contains(where: { $0.transportType == mode.transportType }) {
                            Text(mode.time)
                                .transition(.move(edge: .bottom))
                                .font(.caption)
                        }
                    }
                    .foregroundStyle(.foreground)
                    .opacity(isFetchingRoute ? 0.3 : 1.0)
                    .padding(routes.contains(where: { $0.transportType == mode.transportType }) ? 6 : 15)
                    .frame(maxWidth: .infinity)
                    .background(
                        (selectedRoute?.transportType == mode.route?.transportType) && mode.route != nil
                        ? Color(.systemOrange).opacity(0.6) : Color(UIColor.systemBackground).opacity(0.8)
                        
                    )
                    .transition(.opacity)
                    .clipShape(.rect(cornerRadius: 8))
                    .shadow(
                        color: (selectedRoute?.transportType == mode.route?.transportType && mode.route != nil)
                        ? Color(.systemOrange)
                            : Color(.systemGray4),
                        radius: 3
                    )
                }
                .disabled(isFetchingRoute)
            }
        }
    }

    
    // Shows market name, location and distance to it
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            
            Text(mapItem.name ?? "Unbekannter Markt")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, 0)
                .lineLimit(1)
            
            Text(composeAddress())
                .foregroundStyle(.secondary)
                .font(.subheadline)
                .lineLimit(1)
            
                HStack(spacing: 2){
                    Image(systemName: "point.topleft.down.to.point.bottomright.curvepath.fill")
                        .opacity(self.selectedRoute != nil ? 1 : 0)

                    Text(self.selectedRoute != nil ? "\(formatDistance(selectedRoute!.distance)) entfernt" : "")
                       
                }
                .font(.subheadline)
                .foregroundStyle(isHighlighted ? Color(.systemOrange) : .gray)
                .transition(.opacity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var infoSection: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Webseite")
                    .textCase(.uppercase)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let url = mapItem.url {
                    Link(websiteLink, destination: url)
                        .font(.callout)
                        .lineLimit(1)
                        .foregroundColor(Color(.systemOrange))
                } else {
                    Text("-")
                        .font(.callout)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Telefon")
                    .textCase(.uppercase)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if let phoneNumber = mapItem.phoneNumber, !phoneNumber.isEmpty {
                    Link(phoneNumber, destination: URL(string: "tel://\(phoneNumber)")!)
                        .font(.callout)
                        .lineLimit(1)
                        .foregroundColor(Color(.systemOrange))
                } else {
                    Text("-")
                        .font(.callout)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var appleMapsButtonSection: some View {
        HStack(alignment: .center, spacing: 0) {
            
            Button(action: openInAppleMaps) {
                HStack {
                    Image(systemName: "map")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                    Text("In Karten-App öffnen")
                        .font(.callout)
                        .lineLimit(1)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 12)
            .foregroundStyle(Color(.systemOrange))
            .background(.background.opacity(0.8))
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color:  Color(.systemGray4) ,radius: 3)

            Spacer()
            
            // Placeholder Button
            Button(action: openInAppleMaps) {
                HStack {
                    Image(systemName: "signpost.right.and.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                    Text("Wegbeschreibung")
                        .font(.callout)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 12)
            .foregroundStyle(Color(.systemOrange))
            .background(.background.opacity(0.8))
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color:  Color(.systemGray4) ,radius: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    var lookAroundSection: some View {
        ZStack(alignment: .center) {
            LookAroundPreview(initialScene: lookAroundScene)
                .transition(.opacity)
                .frame(height: 128)
                .clipShape(.rect(cornerRadius: 8))
                .blur(radius: lookAroundScene == nil ? 1 : 0)
                .opacity(lookAroundScene != nil ? 1 : 0.5)
                .disabled(lookAroundScene == nil)
            
            if lookAroundScene == nil {
                Text("Umschauen ist für diesen Ort nicht verfügbar.")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color(.systemGray3).opacity(0.8))
                    .clipShape(.rect(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .shadow(color: Color(.systemGray2) ,radius: 4)
    }
    
    struct TravelMode {
        let icon: String
        let time: String
        let transportType: MKDirectionsTransportType
        let route: RouteData?
        let isSelected: Bool = false
    }
    
    var travelModes: [TravelMode] {
        [
            TravelMode(
                icon: "car",
                time: formatTime(minutes: routes.first(where: { $0.transportType == .automobile })?.eta),
                transportType: .automobile,
                route:  routes.first(where: { $0.transportType == .automobile })
            ),
             TravelMode(
                icon: "figure.walk",
                time: formatTime(minutes: routes.first(where: { $0.transportType == .walking })?.eta),
                transportType: .walking,
                route:  routes.first(where: { $0.transportType == .walking })
            ),
            TravelMode(
                icon: "bus",
                time: formatTime(minutes: routes.first(where: { $0.transportType == .transit })?.eta),
                transportType: .transit,
                route:  routes.first(where: { $0.transportType == .transit })
            ),
        ]
    }
}