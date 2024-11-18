//
//  RecipeFilter.swift
//  ios-project
//
//  Created by Henry Harder on 16.11.24.
//

import Foundation

class RecipeFilter {
    static func filter(
        items: [Recipe],
        searchText: String,
        excludeNotRegionallyRecipes: Bool,
        selectedMonth: Month
    ) -> [Recipe] {
        
        var filteredItems = items
        
        // Filter nach Suchtext
        if !searchText.isEmpty {
            filteredItems = filteredItems.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter nach Verfügbarkeit
        if excludeNotRegionallyRecipes {
            filteredItems = filteredItems.filter { recipe in
                // Überprüfe, ob für das Rezept saisonale Daten für den ausgewählten Monat existieren
                let seasonalDataForMonth = recipe.seasonalData.first { seasonal in
                    seasonal.month == selectedMonth
                }
                
                if let seasonalData = seasonalDataForMonth {
                    return seasonalData.availability == "ja"
                }
                
                // Wenn keine saisonalen Daten für den Monat vorhanden sind, anzeigen
                return false
            }
        } else {
            // Wenn "excludeNotRegionally" nicht aktiv ist, lasse auch für Rezepte mit Produkten, die "nicht regional verfügbar" und "auf Lager" sind, durch
            filteredItems = filteredItems.filter { recipe in
                let seasonalDataForMonth = recipe.seasonalData.first { seasonal in
                    seasonal.month == selectedMonth
                }
                return seasonalDataForMonth != nil
            }
        }
        
        // Filter nach Monat
        filteredItems = filteredItems.filter { recipe in
            // Nur Produkte anzeigen, die im ausgewählten Monat verfügbar sind
            return recipe.seasonalData.contains { seasonalData in
                seasonalData.month == selectedMonth
            }
        }
        
        return filteredItems
    }
}
