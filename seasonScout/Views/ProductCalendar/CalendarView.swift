//
//  CalendarView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct CalendarView: View {

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemOrange
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black], for: .selected)
    }

    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false

    @State private var searchText = ""
    @State private var selectedMonth = Month.allCases[
        Calendar.current.component(.month, from: Date()) - 1]
    @State private var selectedProductType: SelectedProductType = .all
    @State private var selectedProductIsFavorite = false
    @State private var excludeNotRegionally = true
    @State private var showFilters = false

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
                if !selectedProductIsFavorite {
                    MonthSelectionView(selectedMonth: $selectedMonth)
                }

                Button(action: {
                    withAnimation {
                        showFilters.toggle()
                    }
                }) {
                    HStack {
                        Text(
                            showFilters
                                ? "Filter ausblenden" : "Filter anzeigen"
                        )
                        .font(.headline)
                        .foregroundColor(isDarkModeEnabled ? .white : .black)
                        Image(
                            systemName: showFilters
                                ? "chevron.up" : "chevron.down"
                        )
                        .font(.headline)
                    }
                }
                .padding(.top)
                .padding(.bottom, 2)

                if showFilters {
                    Picker(
                        "Wähle ein Produkttyp aus",
                        selection: $selectedProductType
                    ) {
                        ForEach(SelectedProductType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                ProductListView(
                    products: filteredProducts, selectedMonth: selectedMonth)
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Suche nach Produkten"
            )
            .navigationTitle("Kalender")
            .toolbar {
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
                            isDarkModeEnabled ? .white : Color(.systemYellow))
                    }
                    .onChange(of: isDarkModeEnabled) { _, _ in
                        // Trigger the appearance update
                        updateAppearance()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if selectedProductIsFavorite {
                        Button {

                        } label: {
                            Image(
                                systemName: excludeNotRegionally
                                    ? "leaf.fill" : "ferry.fill"
                            )
                            .foregroundColor(Color(.systemGray))
                        }
                    } else {
                        Button {
                            excludeNotRegionally.toggle()
                        } label: {
                            Image(
                                systemName: excludeNotRegionally
                                    ? "leaf.fill" : "ferry.fill"
                            )
                            .contentTransition(.symbolEffect(.replace.offUp))
                            .foregroundColor(
                                excludeNotRegionally
                                    ? Color(.systemGreen) : Color(.systemRed))
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedProductIsFavorite.toggle()
                    } label: {
                        Image(
                            systemName: selectedProductIsFavorite
                                ? "heart.fill" : "heart.slash.fill"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(
                            selectedProductIsFavorite
                                ? Color(.systemPink) : Color(.systemPink))
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
