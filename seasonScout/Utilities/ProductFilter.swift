//
//  ProductFilter.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import Foundation

class ProductFilter {
    static func filter(
        items: [Product],
        searchText: String,
        selectedProductType: SelectedProductType,
        selectedProductIsFavorite: Bool,
        excludeNotRegionally: Bool,
        selectedMonth: Month
    ) -> [Product] {
        
        var filteredItems = items
        
        // Filter nach Suchtext
        if !searchText.isEmpty {
            filteredItems = filteredItems.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter für Obst
        if selectedProductType == .fruit {
            filteredItems = filteredItems.filter { product in
                product.type == .fruit
            }
        }
        
        // Filter für Gemüse
        else if selectedProductType == .vegetable {
            filteredItems = filteredItems.filter { product in
                product.type == .vegetable
            }
        }
        
        // Filter für Salat
        else if selectedProductType == .salad {
            filteredItems = filteredItems.filter { product in
                product.type == .salad
            }
        }
        
        // Filter für Kräuter
        else if selectedProductType == .herb {
            filteredItems = filteredItems.filter { product in
                product.type == .herb
            }
        }
        
        // Filter nach Favoriten
        if selectedProductIsFavorite {
            filteredItems = filteredItems.filter { product in
                product.isFavorite == selectedProductIsFavorite
            }
        } else {
            // Filter nach Monat
            filteredItems = filteredItems.filter { product in
                // Nur Produkte anzeigen, die im ausgewählten Monat verfügbar sind
                return product.seasonalData.contains { seasonalData in
                    seasonalData.month == selectedMonth
                }
            }
        }
        
        // Filter nach Verfügbarkeit (regionale Produkte und Produkte, die auf Lager sind)
        if excludeNotRegionally && !selectedProductIsFavorite {
            filteredItems = filteredItems.filter { product in
                // Überprüfe, ob für das Produkt saisonale Daten für den ausgewählten Monat existieren
                let seasonalDataForMonth = product.seasonalData.first { seasonal in
                    seasonal.month == selectedMonth
                }
                
                // Produkte, die auf Lager sind, auch anzeigen
                if let seasonalData = seasonalDataForMonth {
                    return seasonalData.availability == .regionally || seasonalData.availability == .inStock
                }
                
                // Wenn keine saisonalen Daten für den Monat vorhanden sind, anzeigen
                return false
            }
        } else {
            // Wenn "excludeNotRegionally" nicht aktiv ist, lasse auch Produkte mit "nicht regional verfügbar" und "auf Lager" durch
            filteredItems = filteredItems.filter { product in
                let seasonalDataForMonth = product.seasonalData.first { seasonal in
                    seasonal.month == selectedMonth
                }
                return seasonalDataForMonth != nil
            }
        }
        
        return filteredItems
    }
}
