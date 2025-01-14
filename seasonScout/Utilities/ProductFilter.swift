class ProductFilter {
    // Method to filter a list of products based on multiple criteria
    static func filter(
        items: [Product],  // List of products to filter
        searchText: String,  // Search text to filter products by name
        selectedProductType: SelectedProductType,  // Selected product type (e.g., fruit, vegetable)
        selectedProductIsFavorite: Bool,  // Whether to filter by favorite status
        excludeNotRegionally: Bool,  // Whether to exclude non-regionally available products
        selectedMonth: Month,  // The month to filter products by their seasonal availability
        triggerUpdate: Bool  // Used to recalculate the list of filtered products
    ) -> [Product] {

        var filteredItems = items  // Start with the full list of products

        // Filter by search text if provided
        if !searchText.isEmpty {
            filteredItems = filteredItems.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter products by the selected type (e.g., fruit, vegetable, etc.)
        if selectedProductType == .fruit {
            filteredItems = filteredItems.filter { product in
                product.type == .fruit
            }
        } else if selectedProductType == .vegetable {
            filteredItems = filteredItems.filter { product in
                product.type == .vegetable
            }
        } else if selectedProductType == .salad {
            filteredItems = filteredItems.filter { product in
                product.type == .salad
            }
        } else if selectedProductType == .herb {
            filteredItems = filteredItems.filter { product in
                product.type == .herb
            }
        }

        // Filter products based on whether they are marked as favorites
        if selectedProductIsFavorite {
            filteredItems = filteredItems.filter { product in
                product.isFavorite == selectedProductIsFavorite
            }
        } else {
            // Filter products based on seasonal availability for the selected month
            filteredItems = filteredItems.filter { product in
                // Only show products available in the selected month
                return product.seasonalData.contains { seasonalData in
                    seasonalData.month == selectedMonth
                }
            }
        }

        // Filter based on regional availability (and in-stock status) if requested
        if excludeNotRegionally && !selectedProductIsFavorite {
            filteredItems = filteredItems.filter { product in
                // Check if seasonal data exists for the selected month
                let seasonalDataForMonth = product.seasonalData.first {
                    seasonal in
                    seasonal.month == selectedMonth
                }

                // Only include products that are regionally available or in stock
                if let seasonalData = seasonalDataForMonth {
                    return seasonalData.availability == .regionally
                        || seasonalData.availability == .inStock
                }

                return false  // Exclude if no seasonal data for the month
            }
        } else {
            // If excludeNotRegionally is not active, allow products regardless of availability
            filteredItems = filteredItems.filter { product in
                let seasonalDataForMonth = product.seasonalData.first {
                    seasonal in
                    seasonal.month == selectedMonth
                }
                return seasonalDataForMonth != nil  // Only include products with seasonal data for the month
            }
        }

        return filteredItems  // Return the filtered list of products
    }
}
