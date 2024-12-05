//
//  MarketDetailSheet.swift
//  ios-project
//
//  Created by Poimandres on 04.12.24.
//

// Shows more information about a selected market on the map

import SwiftUI
import MapKit

struct MarketDetailSheet: View {
    
    let mapViewModel: MapViewModel
    
    // l; entfernung,l; fuss, rad, auto, l; location l; telefon, l; website, fahrtweg / laufweg, l; route u karten l; umschauen
    
    var body: some View {
        VStack(alignment: .leading){
            Text(mapViewModel.selectedMarker!.name ?? "Unbekannter Markt")
                .font(.title3)
                .fontWeight(.semibold)
                        
            HStack{
                Group {
                    VStack {
                        Image(systemName: "car.circle")
                            .font(.title)
                            .fontWeight(.thin)
                        Text("12 Minuten")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "figure.outdoor.cycle.circle")
                            .font(.title)
                            .fontWeight(.thin)
                        
                        Text("34 Minuten")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "figure.walk.circle")
                            .font(.title)
                            .fontWeight(.thin)
                        
                        Text("1 Stunde")
                            .font(.caption)
                    }
                }
                .padding(4)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray5))
                .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.bottom, 6)
            
            // falls kein tel oder web: maxWidth setzen
            Divider()
            HStack(alignment: .top) {
                Group {
                    VStack(alignment: .leading) {
                        Text("Entfernung")
                            .textCase(.uppercase)
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("1.2km")
                            .font(.callout)

                    }
                    .padding(.trailing, 4)
                    
                    VStack(alignment: .leading) {
                        Text("Telefon")
                            .textCase(.uppercase)
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("0815 667 321 69")
                            .font(.callout)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Website")
                            .textCase(.uppercase)
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("bauhausi.info")
                            .font(.callout)
                            .lineLimit(1)
                    }
                    .padding(.trailing, 4)
                }
                .frame(alignment: .leading)
            }
            Divider()

            VStack {
                Text("Öffnungszeiten")
                Text("Aktuell")
                
                Text("Mo...")
                Text("Di...")
            }
            
            // umschauen map view
            
            HStack{
                //Button(action: {}, label: "In Karten anzeigen")
                
                //Button(action: {}, label: "Anweisungen anzeigen")
            }

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

//// MockMarket class
//class MockMarket: ObservableObject {
//    @Published var isSheetPresented: Bool = false
//    private var mockMKMapItem: MKMapItem?
//    
//    func createMockMKMapItem() -> MKMapItem {
//        let placemark = MKPlacemark(
//            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
//            addressDictionary: [
//                "Name": "Mock Market",
//                "SubLocality": "Mock SubLocality",
//                "City": "San Francisco",
//                "State": "California",
//                "Street": "123 Mock St",
//                "ZIP": "94103"
//            ]
//        )
//        
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "Mock Market"
//        mapItem.phoneNumber = "+1-555-123-4567"
//        mapItem.url = URL(string: "https://mockmarket.com")
//        
//        self.mockMKMapItem = mapItem
//        return mapItem
//    }
//    
//    func getMockMKMapItem() -> MKMapItem {
//        if let item = mockMKMapItem {
//            return item
//        } else {
//            return createMockMKMapItem()
//        }
//    }
//}
//
//// Extension for Identifiable MKMapItem (no longer needed in this case)
//extension MKMapItem: @retroactive Identifiable {
//    public var id: UUID {
//        UUID()
//    }
//}
//
//#Preview {
//    @Previewable @StateObject var mockMarket = MockMarket()
//
//    ZStack {
//        Color(.gray).ignoresSafeArea()
//        VStack {
//            Text("zo zo")
//            Button("Open Sheet") {
//                mockMarket.isSheetPresented = true
//            }
//            .buttonStyle(.borderedProminent)
//        }
//    }
//    .sheet(isPresented: $mockMarket.isSheetPresented) {
//        //MarketDetailSheet()
//            .presentationDetents([.fraction(0.3) ,.medium])
//            .presentationDragIndicator(.visible)
//    }
//}
