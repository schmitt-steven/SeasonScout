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
                                Image(systemName: "arrow.left.and.right").foregroundStyle(.orange)
                                Text("\(Int(mapViewController.searchRadiusInMeters)/1000)km")
                                    .foregroundColor(mapViewController.isSearchRadiusBeingEdited ? .accentColor : .primary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background.opacity(0.9))
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
                        value: $mapViewController.searchRadiusInMeters,
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
                    .onChange(of: mapViewController.searchRadiusInMeters) {
                        mapViewController.isMapMarkerVisible = false
                        mapViewController.updateCameraPosition(to: mapViewController.locationManager.location?.coordinate)
                    }
                    .padding(.trailing, 10)
                    
                    Button(action: {
                        withAnimation(.smooth){
                            mapViewController.isRadiusSliderVisible.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName: "arrow.left.and.right").foregroundStyle(.orange)
                            Text("\(Int(mapViewController.searchRadiusInMeters)/1000)km")
                                .foregroundColor(mapViewController.isSearchRadiusBeingEdited ? .accentColor : .primary)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.background.opacity(0.9))
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6).opacity(0.8))
                        .shadow(radius: 6)
                )
                
            }
            .padding(6)
            .padding(.bottom, 25)
            .transition(.move(edge: .leading))
        }
    }
}
