import SwiftUI

/// A view that displays a calendar interface with filters for products based on type, favorites, and regional availability.
struct CalendarView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool =
        false  // Store the dark mode preference
    @State private var searchText = ""  // Search text for product filtering
    @State private var selectedMonth = Month.allCases[
        Calendar.current.component(.month, from: Date()) - 1]  // Set the current month as the default selected month
    @State private var selectedProductType: SelectedProductType = .all  // Default product type filter set to 'all'
    @State private var selectedProductIsFavorite = false  // Filter for showing only favorite products
    @State private var excludeNotRegionally = true  // Filter for excluding non-regional products
    @State private var showFilters = false  // State to toggle showing filters

    /// Filtered products based on the search text, product type, favorite status, and regional availability
    var filteredProducts: [Product] {
        ProductFilter.filter(
            items: Product.products,
            searchText: searchText,
            selectedProductType: selectedProductType,
            selectedProductIsFavorite: selectedProductIsFavorite,
            excludeNotRegionally: excludeNotRegionally,
            selectedMonth: selectedMonth
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Month selection view appears if favorites filter is not active
                if !selectedProductIsFavorite {
                    MonthSelectionView(selectedMonth: $selectedMonth)
                }

                if showFilters {
                    VStack {
                        // Picker to choose product type (e.g., fruits, vegetables, etc.)
                        Picker(
                            "Wähle ein Produkttyp aus",
                            selection: $selectedProductType
                        ) {
                            ForEach(SelectedProductType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 2)

                        // Toggle to show/hide non-regional products
                        Toggle(
                            "Nicht regionale Produkte ausblenden",
                            isOn: $excludeNotRegionally
                        )
                        .toggleStyle(.switch)
                        .padding(.top)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 2)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 1.0, anchor: .top),
                            removal: .opacity)
                    )
                    .animation(
                        .spring(
                            response: 0.4, dampingFraction: 0.75,
                            blendDuration: 0.5), value: showFilters)
                }

                // Display the filtered product list
                ProductListView(
                    products: filteredProducts, selectedMonth: $selectedMonth)
                Spacer()
            }
            // Search bar integrated with the navigation bar
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Suche nach Produkten"
            )
            .navigationTitle("Kalender")
            .toolbar {
                // Toolbar with dark mode toggle on the left side
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isDarkModeEnabled.toggle()
                    } label: {
                        Image(
                            systemName: isDarkModeEnabled
                                ? "moon.stars.fill" : "sun.max.fill"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(
                            isDarkModeEnabled ? .white : Color(.systemYellow)
                        )
                        .shadow(
                            color: isDarkModeEnabled
                                ? Color.white
                                : Color(.systemYellow), radius: 5,
                            x: 0, y: 0)
                    }
                    .onChange(of: isDarkModeEnabled) { _, _ in
                        // Trigger the appearance update whenever dark mode changes
                        updateAppearance()
                    }
                }
                // Toolbar with filters toggle on the right side
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(
                            .spring(
                                response: 0.5, dampingFraction: 0.7,
                                blendDuration: 0.5)
                        ) {
                            showFilters.toggle()
                        }
                    } label: {
                        Image(
                            systemName: showFilters
                                ? "line.3.horizontal.decrease.circle.fill"
                                : "line.3.horizontal.decrease.circle"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(Color(.systemOrange))
                        .shadow(
                            color: Color(.systemOrange), radius: 5,
                            x: 0, y: 0)
                    }
                }
                // Toolbar with favorites toggle on the right side
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedProductIsFavorite.toggle()
                    } label: {
                        Image(
                            systemName: selectedProductIsFavorite
                                ? "heart.fill" : "heart.slash.fill"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(Color(.systemPink))
                        .shadow(
                            color: Color(.systemPink), radius: 5,
                            x: 0, y: 0)
                    }
                }
            }
        }
    }

    // Update the application's appearance
    private func updateAppearance() {
        // Update UIKit interface style for compatibility
        let windowScene =
            UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.overrideUserInterfaceStyle =
            isDarkModeEnabled ? .dark : .light
    }
}

#Preview {
    CalendarView()
}
