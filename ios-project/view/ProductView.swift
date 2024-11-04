import SwiftUI
import CoreData

struct ProductView: View {
    
    @State private var isNotificationEnabled = false
    
    var body: some View {
        
        let allProducts = Product.products
        
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                // Main Product Information Section
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(allProducts[44].name).font(.headline)
                        Text("lat. \(allProducts[44].botanicalName)")
                        Text("Kategorie: " + allProducts[44].type.rawValue)
                        Text("Unterkategorie: " + allProducts[44].subtype.rawValue)
                        Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
                        /*
                        Text("Verfügbarkeit:")
                        ForEach(allProducts[44].seasonalData.keys.map { $0 }, id: \.self) { month in
                            let availability = allProducts[44].seasonalData[month] ?? []
                            let availabilityText = availability.map { $0.rawValue }.joined(separator: ", ")
                            Text("\(month.rawValue): \(availabilityText)")
                        }*/
 
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Image("apple")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .background(Color.white)
                        .padding(.leading, 10)
                }
                .padding()
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Text("Rezepte")
                            .frame(width: 150, height: 50)
                            .cornerRadius(10)
                    }
                    Button(action: {}) {
                        Text("Reg. Verkäufer/Karte")
                            .frame(width: 200, height: 50)
                            .cornerRadius(10)
                    }
                }
                
                .padding(.bottom, 10)
                
                .frame(maxWidth: .infinity)
                
                Divider() // Divider between main info and showcase section
                
                // Similar Fruits Showcase Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Regionale Alternativen")
                        .font(.headline)
                    
                    HStack(spacing: 15) {
                        Image("orange")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                        
                        Image("birne")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                        Image("banane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Notification Toggle
                    Toggle(isOn: $isNotificationEnabled) {
                        Text("Benachrichtige mich, sobald das Produkt erhältlich ist!")
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProductView()
}
