import SwiftUI
import CoreData

struct ProductInfoView: View {
    
    @State private var isNotificationEnabled = false
    @State private var isFavorite = false
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    var availability: String {
        var availabilityString = ""
        for month in product.seasonalData {
            let monthAvailability = month.availability.rawValue
            let monthName = month.month.rawValue
            
            if monthAvailability != "nicht regional verfügbar" {
                availabilityString.append("\(monthName): \(monthAvailability)\n")
            }
        }
        return availabilityString
    }
    
    let product: Product

    let productEmojis = ProductEmojis()
    
    var body: some View {
        
        
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                // Main Product Information Section
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(product.name)
                                .font(.headline)
                                .padding(.bottom, 10)
                            
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .blue)
                                .font(.system(size: 30))
                                .onTapGesture {
                                    isFavorite.toggle()
                                }
                                .padding(.bottom, 10)
                        }
                        Text("lat. \(product.botanicalName)")
                        Text("Kategorie: " + product.type.rawValue)
                        Text("Unterkategorie: " + product.subtype.rawValue)
                    }
                    .padding()
                                    
                    Spacer()
                    Text(ProductEmojis.productEmojis[product.name] ?? "﹖")
                        .font(.system(size: 100))
                        .padding(10)
                }
                .background(Color(UIColor.systemGray6))
                .clipShape(.rect(cornerRadius: 15))
                .padding([.leading, .trailing], 20)
                .shadow(color: .gray, radius: 2)
                
                ExpandableAvailabilityView(title: "Verfügbarkeit", content: availability)
                /*
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Text("Zur Karte")
                            .frame(width: 200, height: 50)
                            .cornerRadius(10)
                    }
                }*/
                
                //TODO: Rezeptliste (Produkt in der Zutatenliste enthalten)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Ähnliche Produkte")
                        .font(.headline)
                        .padding()

                    SimilarProductView(shownProduct: product)
                        .padding(.horizontal)
                                        
                    .frame(maxWidth: .infinity)
                }
                .background(Color(UIColor.systemGray6))
                .clipShape(.rect(cornerRadius: 15))
                .padding([.leading, .trailing], 20)
                .shadow(color: .gray, radius: 2)
                
                VStack() {
                    Toggle(isOn: $isNotificationEnabled) {
                        Text("Benachrichtige mich, sobald das Produkt erhältlich ist!")
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    let product = Product.products[44]
    ProductInfoView(product: product)
}
