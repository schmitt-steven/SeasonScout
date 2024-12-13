//
//  RadiusSlider.swift
//  ios-project
//
//  Created by Poimandres on 28.11.24.

import SwiftUI
import MapKit

struct RadiusSlider: View {
    
    @ObservedObject var mapViewController: MapViewModel
    let searchRadiusRange = 5_000.0...50_000.0  // in meters
    
    var body: some View {
        
        if(!mapViewController.isRadiusSliderVisible){
            
                VStack(alignment: .leading){
                    Spacer()
                    HStack{
                        Button(action: {
                            withAnimation(.smooth()){
                                mapViewController.isRadiusSliderVisible.toggle()
                            }
                        }) {
                            HStack{
                                Image(systemName: "mappin.and.ellipse").foregroundStyle(.orange)
                                Text("\(Int(mapViewController.currentSearchRadiusInMeters)/1000)km")
                                    .foregroundColor(mapViewController.isSearchRadiusBeingEdited ? .accentColor : .primary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.thickMaterial)
                            )
                        }
                        .padding(.bottom, 10)
                        Spacer()
                    }
                    
                }
                .padding(6)
                .padding(.bottom, 15)
                .transition(.move(edge: .trailing))
            
        }
        else {
            VStack{
                Spacer()
                HStack{
                    Slider(
                        value: $mapViewController.currentSearchRadiusInMeters,
                        in: searchRadiusRange,
                        step: 5_000
                    ){
                        Text("Slider Position")
                    } minimumValueLabel: {
                        Text("\(Int(searchRadiusRange.lowerBound)/1000)km")
                    } maximumValueLabel: {
                        Text("\(Int(searchRadiusRange.upperBound)/1000)km")
                    } onEditingChanged: { editing in
                        mapViewController.isSearchRadiusBeingEdited = editing
                        if !editing {
                            Task { @MainActor in
                                await mapViewController.searchForMarkets(
                                    using: mapViewController.locationManager.location)
                            }
                        }
                    }
                    .onChange(of: mapViewController.currentSearchRadiusInMeters) {
                        mapViewController.isMapMarkerVisible = false
                        mapViewController.updateCameraPosition(to: mapViewController.locationManager.location?.coordinate)
                    }
                    .padding(.trailing, 12)
                    
                    Button(action: {
                        withAnimation(.smooth){
                            mapViewController.isRadiusSliderVisible.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName: "mappin.and.ellipse").foregroundStyle(.orange)
                            Text("\(Int(mapViewController.currentSearchRadiusInMeters)/1000)km")
                                .foregroundColor(mapViewController.isSearchRadiusBeingEdited ? .accentColor : .primary)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.bar)
                                .shadow(radius: 4)
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.bar)
                        .shadow(radius: 6)
                )
                
            }
            .padding(6)
            .padding(.bottom, 25)
            .transition(.move(edge: .leading))
        }
    }
}
