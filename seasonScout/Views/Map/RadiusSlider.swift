import MapKit
import SwiftUI

struct RadiusSlider: View {
    @ObservedObject var mapViewController: MapViewModel
    let searchRadiusRange = 5_000.0...50_000.0  // Range for search radius in meters

    var body: some View {
        // Check if the radius slider is hidden
        if !mapViewController.isRadiusSliderVisible {

            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Button(action: {
                        // Toggle the visibility of the radius slider with animation
                        withAnimation(.smooth()) {
                            mapViewController.isRadiusSliderVisible.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundStyle(.orange)
                            Text(
                                "\(Int(mapViewController.currentSearchRadiusInMeters)/1000)km"
                            )
                            .foregroundColor(
                                mapViewController.isSearchRadiusBeingEdited
                                    ? .accentColor : .primary)
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
            .transition(.move(edge: .trailing))  // Animation for showing the slider

        } else {
            VStack {
                Spacer()
                HStack {
                    // Slider to adjust the search radius
                    Slider(
                        value: $mapViewController.currentSearchRadiusInMeters,
                        in: searchRadiusRange,
                        step: 5_000  // Adjust the radius in steps of 5,000 meters
                    ) {
                        Text("Slider Position")
                    } minimumValueLabel: {
                        Text("\(Int(searchRadiusRange.lowerBound)/1000)km")
                    } maximumValueLabel: {
                        Text("\(Int(searchRadiusRange.upperBound)/1000)km")
                    } onEditingChanged: { editing in
                        // Handle slider editing state
                        mapViewController.isSearchRadiusBeingEdited = editing
                        if !editing {
                            // Trigger market search when editing is finished
                            Task { @MainActor in
                                await mapViewController.searchForMarkets(
                                    using: mapViewController.locationManager
                                        .location)
                            }
                        }
                    }
                    .onChange(of: mapViewController.currentSearchRadiusInMeters)
                    {
                        // Update map marker visibility and camera position
                        mapViewController.isMapMarkerVisible = false
                        mapViewController.updateCameraPosition(
                            to: mapViewController.locationManager.location?
                                .coordinate)
                    }
                    .padding(.trailing, 12)

                    // Button to toggle the slider visibility
                    Button(action: {
                        withAnimation(.smooth) {
                            mapViewController.isRadiusSliderVisible.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundStyle(.orange)
                            Text(
                                "\(Int(mapViewController.currentSearchRadiusInMeters)/1000)km"
                            )
                            .foregroundColor(
                                mapViewController.isSearchRadiusBeingEdited
                                    ? .accentColor : .primary)
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
                        .fill(.thickMaterial)
                        .shadow(radius: 6)
                )

            }
            .padding(6)
            .padding(.bottom, 25)
            .transition(.move(edge: .leading))  // Animation for hiding the slider
        }
    }
}
