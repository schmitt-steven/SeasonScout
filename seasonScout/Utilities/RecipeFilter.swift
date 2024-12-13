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
        selectedRecipeCategory: RecipeCategory?,
        selectedRecipeEffort: Level?,
        selectedRecipePrice: Level?,
        selectedRecipeIsFavorite: Bool,
        selectedRecipeIsForGroups: Bool,
        selectedRecipeIsVegetarian: Bool,
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
        
        // Filter nach Kategorie
        if let selectedCategory = selectedRecipeCategory {
            filteredItems = filteredItems.filter { recipe in
                recipe.category == selectedCategory
            }
        }
                
        // Filter nach Aufwand
        if let selectedEffort = selectedRecipeEffort {
            filteredItems = filteredItems.filter { recipe in
                recipe.effort == selectedEffort
            }
        }
        
        // Filter nach Kosten
        if let selectedPrice = selectedRecipePrice {
            filteredItems = filteredItems.filter { recipe in
                recipe.price == selectedPrice
            }
        }
        
        // Filter nach Für Gruppen
        if selectedRecipeIsForGroups {
            filteredItems = filteredItems.filter { recipe in
                recipe.isForGroups == selectedRecipeIsForGroups
            }
        }
        
        // Filter nach Vegetarisch
        if selectedRecipeIsVegetarian {
            filteredItems = filteredItems.filter { recipe in
                recipe.isVegetarian == selectedRecipeIsVegetarian
            }
        }
        
        // Filter nach Favoriten
        if selectedRecipeIsFavorite {
            filteredItems = filteredItems.filter { recipe in
                recipe.isFavorite == selectedRecipeIsFavorite
            }
        } else {
            // Filter nach Monat
            filteredItems = filteredItems.filter { recipe in
                // Nur Rezepte anzeigen, die im ausgewählten Monat verfügbar sind
                return recipe.seasonalData.contains { seasonalData in
                    seasonalData.month == selectedMonth
                }
            }
        }
        
        // Filter nach Verfügbarkeit
        if excludeNotRegionallyRecipes && !selectedRecipeIsFavorite {
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
        
        return filteredItems
    }
}
