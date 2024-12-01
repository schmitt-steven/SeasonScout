// Zwischenlösung, bis es Bilder zu allen Produketen gibt

import Foundation

struct ProductEmojis {
    static let productEmojis: [String: String] = [
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
        "Brombeeren": "🍇", // Blackberries
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

    // A computed property to return the emoji for a product
    static func emoji(forProduct productName: String) -> String {
        return productEmojis[productName] ?? "🍏" // Default to 🍏 if not found
    }
}
