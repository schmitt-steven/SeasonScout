class RecipeFilter {
    // Method to filter a list of recipes based on multiple criteria
    static func filter(
        items: [Recipe],  // List of recipes to filter
        searchText: String,  // Search text to filter recipes by title
        selectedRecipeCategory: RecipeCategory?,  // Selected recipe category (e.g., dessert, main dish)
        selectedRecipeEffort: Level?,  // Filter recipes by effort level (e.g., easy, medium, hard)
        selectedRecipePrice: Level?,  // Filter recipes by price level
        selectedRecipeIsFavorite: Bool,  // Whether to filter by favorite status
        selectedRecipeIsForGroups: Bool,  // Whether to filter by whether the recipe is for groups
        selectedRecipeIsVegetarian: Bool,  // Whether to filter by vegetarian recipes
        excludeNotRegionallyRecipes: Bool,  // Whether to exclude recipes with non-regional ingredients
        selectedMonth: Month,  // Month to filter recipes based on seasonal ingredients
        triggerUpdate: Bool
    ) -> [Recipe] {

        var filteredItems = items  // Start with the full list of recipes

        // Filter by search text if provided
        if !searchText.isEmpty {
            filteredItems = filteredItems.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter by selected category, if specified
        if let selectedCategory = selectedRecipeCategory {
            filteredItems = filteredItems.filter { recipe in
                recipe.category == selectedCategory
            }
        }

        // Filter by effort level, if specified
        if let selectedEffort = selectedRecipeEffort {
            filteredItems = filteredItems.filter { recipe in
                recipe.effort == selectedEffort
            }
        }

        // Filter by price level, if specified
        if let selectedPrice = selectedRecipePrice {
            filteredItems = filteredItems.filter { recipe in
                recipe.price == selectedPrice
            }
        }

        // Filter by whether the recipe is for groups
        if selectedRecipeIsForGroups {
            filteredItems = filteredItems.filter { recipe in
                recipe.isForGroups == selectedRecipeIsForGroups
            }
        }

        // Filter by vegetarian recipes
        if selectedRecipeIsVegetarian {
            filteredItems = filteredItems.filter { recipe in
                recipe.isVegetarian == selectedRecipeIsVegetarian
            }
        }

        // Filter by favorite recipes
        if selectedRecipeIsFavorite {
            filteredItems = filteredItems.filter { recipe in
                recipe.isFavorite == selectedRecipeIsFavorite
            }
        } else {
            // Filter by the selected month for seasonal ingredients
            filteredItems = filteredItems.filter { recipe in
                // Only show recipes available in the selected month
                return recipe.seasonalData.contains { seasonalData in
                    seasonalData.month == selectedMonth
                }
            }
        }

        // Filter by regional availability if requested
        if excludeNotRegionallyRecipes && !selectedRecipeIsFavorite {
            filteredItems = filteredItems.filter { recipe in
                // Check if seasonal data exists for the selected month
                let seasonalDataForMonth = recipe.seasonalData.first {
                    seasonal in
                    seasonal.month == selectedMonth
                }

                if let seasonalData = seasonalDataForMonth {
                    return seasonalData.availability == "ja"  // "ja" means regional availability
                }

                return false  // Exclude if no seasonal data for the month
            }
        } else {
            // If excludeNotRegionally is not active, allow recipes with ingredients that are not regionally available
            filteredItems = filteredItems.filter { recipe in
                let seasonalDataForMonth = recipe.seasonalData.first {
                    seasonal in
                    seasonal.month == selectedMonth
                }
                return seasonalDataForMonth != nil  // Only include recipes with seasonal data for the month
            }
        }

        return filteredItems  // Return the filtered list of recipes
    }
}
