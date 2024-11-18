import SwiftUI
import CoreData

struct ProductView: View {
    
    @State private var isNotificationEnabled = false
    @State private var isFavorite = false
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    let product: Product
    
    let productEmojis: [String: String] = [
        // Vegetables
        "Fenchel": "🥒", // Fennel
        "Grünkohl": "🥬", // Kale
        "Gurke / Salatgurke": "🥒", // Cucumber
        "Kartoffeln": "🥔", // Potatoes
        "Kohlrabi": "🥦", // Kohlrabi
        "Kürbis": "🎃", // Pumpkin
        "Lauch/Porree": "🧅", // Leek
        "Lauch- / Frühlingszwiebeln": "🧅", // Spring onions
        "Mais": "🌽", // Corn
        "Mangold": "🍃", // Swiss chard
        "Mairüben": "🍠", // Spring turnips
        "Karotten": "🥕", // Carrots
        "Paprika": "🌶️", // Bell pepper
        "Pastinaken": "🥔", // Parsnips
        "Radieschen": "🌶️", // Radishes
        "Rosenkohl": "🥦", // Brussels sprouts
        "Rote Bete": "🍠", // Beetroot
        "Rotkohl": "🥬", // Red cabbage
        "Rettich": "🌶️", // Daikon radish
        "Schalotten": "🧅", // Shallots
        "Schwarzwurzeln": "🌱", // Salsify
        "Spargel": "🥬", // Asparagus
        "Spinat": "🍃", // Spinach
        "Spitzkohl": "🥬", // Pointed cabbage
        "Sellerieknollen": "🥬", // Celeriac
        "Staudensellerie": "🥬", // Celery
        "Steckrüben": "🥕", // Rutabaga
        "Tomaten": "🍅", // Tomatoes
        "Topinambur": "🍠", // Jerusalem artichoke
        "Weißkohl": "🥬", // White cabbage
        "Wirsingkohl": "🥬", // Savoy cabbage
        "Zucchini": "🥒", // Zucchini
        "Zuckerschoten": "🍀", // Snow peas
        "Zwiebeln": "🧅", // Onions
        "Apfel": "🍎", // Apple

        // Citrus Fruits
        "Mandarinen": "🍊", // Mandarins
        "Mangos": "🥭", // Mango
        "Pampelmusen": "🍋", // Grapefruit
        "Papayas": "🍍", // Papaya
        "Zitronen": "🍋", // Lemon
        "Batavia": "🍀", // Batavia lettuce

        // Leafy Greens and Herbs
        "Chicorée": "🥗", // Chicory
        "Eichblattsalat": "🥬", // Oak leaf lettuce
        "Eisbergsalat": "🥗", // Iceberg lettuce
        "Endiviensalat": "🥬", // Endive lettuce
        "Feldsalat": "🥗", // Lamb's lettuce
        "Kopfsalat": "🥬", // Head lettuce
        "Lollo Rosso": "🥬", // Lollo Rosso
        "Portulak": "🌱", // Purslane
        "Radicchio": "🥬", // Radicchio
        "Rucola": "🥗", // Arugula
        "Bärlauch": "🌱", // Wild garlic
        "Basilikum": "🌿", // Basil
        "Beifuß": "🌿", // Mugwort
        "Bohnenkraut": "🌿", // Savory
        "Borretsch": "🌿", // Borage
        "Dill": "🌿", // Dill
        "Estragon": "🌿", // Tarragon
        "Kerbel": "🌿", // Chervil
        "Koriander": "🌿", // Coriander
        "Kresse": "🌿", // Cress
        "Liebstöckl": "🌿", // Lovage
        "Lorbeer": "🌿", // Bay leaves
        "Majoran": "🌿", // Marjoram
        "Minze": "🌿", // Mint
        "Oregano": "🌿", // Oregano
        "Petersilie": "🌿", // Parsley
        "Rosmarin": "🌿", // Rosemary
        "Salbei": "🌿", // Sage
        "Schnittlauch": "🌿", // Chives
        "Thymian": "🌿", // Thyme
        "Zitronenmelisse": "🌿", // Lemon balm

        // Other Vegetables
        "Auberginen": "🍆", // Eggplant
        "Artischocken": "🌿", // Artichokes
        "Blumenkohl": "🥦", // Cauliflower
        "Bohnen, grüne": "🍃", // Green beans
        "Bohnen, dicke": "🍃", // Broad beans
        "Brokkoli": "🥦", // Broccoli
        "Butterrüben": "🥕", // Butter rutabaga
        "Champignons": "🍄", // Mushrooms
        "Chinakohl": "🥬", // Chinese cabbage
        "Erbsen": "🍃", // Peas

        // Fruits
        "Aprikose": "🍑", // Apricot
        "Birne": "🍐", // Pear
        "Blaubeeren / Heidelbeeren": "🫐", // Blueberries
        "Brombeeren": "黑莓", // Blackberries
        "Erdbeeren": "🍓", // Strawberries
        "Esskastanien": "🌰", // Chestnuts
        "Himbeeren": "🍇", // Raspberries
        "Haselnüsse": "🌰", // Hazelnuts
        "Holunderbeeren / Flieder": "🍇", // Elderberries
        "Johannisbeeren": "🍇", // Currants
        "Kirschen": "🍒", // Cherries
        "Mirabellen": "🍑", // Mirabelle plums
        "Pflaumen": "🍑", // Plums
        "Preiselbeeren": "🍇", // Cranberries
        "Quitten": "🍏", // Quinces
        "Pfirsiche": "🍑", // Peaches
        "Nektarinen": "🍑", // Nectarines
        "Rhabarber": "🍋", // Rhubarb
        "Stachelbeeren": "🍇", // Gooseberries
        "Walnüsse": "🌰", // Walnuts
        "Wassermelonen": "🍉", // Watermelons
        "Weintrauben": "🍇", // Grapes
        "Tafeltrauben": "🍇", // Table grapes
        "Zwetschgen": "🍑", // Plums
        "Ananas": "🍍", // Pineapple
        "Orangen": "🍊", // Oranges
        "Avocados": "🥑", // Avocados
        "Bananen": "🍌", // Bananas
        "Feigen": "🍇", // Figs
        "Granatäpfel": "🍎", // Pomegranates
        "Grapefruit": "🍋", // Grapefruit
        "Kakis": "🍑", // Persimmons
        "Kiwis": "🥝", // Kiwis
        "Limetten": "🍋", // Limes
        "Litschis": "🍇" // Lychees
    ]

    
    var body: some View {
        
        let allproducts = Product.products
        
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                // Main Product Information Section
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(product.name)
                                .font(.headline)
                            
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .blue)
                                .font(.system(size: 30))
                                .onTapGesture {
                                    isFavorite.toggle()
                                }
                        }
                        Text("lat. \(product.botanicalName)")
                        Text("Kategorie: " + product.type.rawValue)
                        Text("Unterkategorie: " + product.subtype.rawValue)
                    }
                                    
                    Spacer()
                    Text(productEmojis[product.name] ?? "🍏")
                        .font(.system(size: 70))
                }
                .padding()
                
                Text("Verfügbarkeit:").padding()
                ForEach(product.seasonalData, id: \.id) { month in
                    let availability = month.availability.rawValue
                    let monthName = month.month.rawValue
                    
                    if (availability != "nicht regional verfügbar") {
                        Text("\(monthName): \(availability)")
                    }
                }
                .padding(.horizontal, 16)
                
                HStack(spacing: 20) {
                    /*
                    Button(action: {}) {
                        Text("Rezepte")
                            .frame(width: 150, height: 50)
                            .cornerRadius(10)
                    }
                    Button(action: {}) {
                        Text("Reg. Verkäufer/Karte")
                            .frame(width: 200, height: 50)
                            .cornerRadius(10)
                    }*/
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                .frame(maxWidth: .infinity)
                
                Divider() // Divider between main info and showcase section
                
                // Similar Fruits Showcase Section
                VStack(alignment: .leading, spacing: 10) {
                    /*
                    Text("Regionale Alternativen")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
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
                    */
                    // Notification Toggle
                    Toggle(isOn: $isNotificationEnabled) {
                        Text("Benachrichtige mich, sobald das Produkt erhältlich ist!")
                    }
                    .padding(.vertical, 30)
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    let product = Product.products[44]
    ProductView(product: product)
}
