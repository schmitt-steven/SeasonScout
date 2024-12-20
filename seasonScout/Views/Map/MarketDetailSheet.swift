//
//  TravelMode.swift
//  ios-project
//
//  Created by Poimandres on 08.12.24.
//

import SwiftUI
import MapKit

struct MarketDetailSheet: View {

    let mapItem: MKMapItem
    var userCoordinate: CLLocationCoordinate2D
    let defaultTransportType: MKDirectionsTransportType = .automobile
    @ObservedObject var mapViewModel: MapViewModel
    @State var selectedRoute: RouteData? = nil
    @State var lookAroundScene: MKLookAroundScene?
    @State var routes: [RouteData] = []
    @State var isFetchingRoute = false
    @State var isHighlighted = false
    
    internal init(mapViewModel: MapViewModel,mapItem: MKMapItem, userCoordinate: CLLocationCoordinate2D) {
        self.mapViewModel = mapViewModel
        self.mapItem = mapItem
        self.userCoordinate = userCoordinate
    }
    
    var body: some View {
        ZStack{
            
            BlurBackgroundView(style: .prominent)
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
        .onDisappear {
            withAnimation(.easeOut) {
                mapViewModel.shownRoutePolyline = nil
            }
        }
    }
}


extension MarketDetailSheet {
    
    var travelTimeSection: some View {
        HStack(spacing: 16) {
            ForEach(travelModes, id: \.icon) { mode in
                Button(action: {updateRouteInformation(mode: mode)}) {
                    VStack {
                        Image(systemName: "\(mode.icon)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.top, 2)
                        
                        if (selectedRoute?.transportType == mode.transportType && mode.route != nil) {
                            Text(mode.time)
                                .transition(.move(edge: .bottom))
                                .font(.caption)
                        }
                    }
                    .foregroundStyle(.foreground)
                    .opacity(isFetchingRoute ? 0.3 : 1.0)
                    .padding(mode.transportType == selectedRoute?.transportType ? 6 : 15)
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
            
            Button(action: openInMaps) {
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
            
            Button(action: {openInMapsWithDirections()}) {
                HStack {
                    Image(systemName: "signpost.right.and.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                    Text("Route anzeigen")
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
