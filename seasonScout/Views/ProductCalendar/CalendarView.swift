//
//  CalendarView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct CalendarView: View {
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

                if showFilters {
                    VStack {
                        Picker(
                            "Wähle ein Produkttyp aus",
                            selection: $selectedProductType
                        ) {
                            ForEach(SelectedProductType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                        
                        Toggle("Nicht regionale Produkte anzeigen", isOn: $excludeNotRegionally)
                            .toggleStyle(.switch)
                            .padding(.top)
                            .padding(.horizontal)
                            .padding(.bottom, 2)
                    }
                    .transition(.asymmetric(insertion: .scale(scale: 1.0, anchor: .top),
                                            removal: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.5), value: showFilters)
                }

                ProductListView(
                    products: filteredProducts, selectedMonth: selectedMonth)
                Spacer()
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
                            isDarkModeEnabled ? .white : Color(.systemYellow)
                        )
                        .shadow(
                            color: excludeNotRegionally
                                ? Color.white
                                : Color(.systemYellow), radius: 10,
                            x: 0, y: 0)
                    }
                    .onChange(of: isDarkModeEnabled) { _, _ in
                        // Trigger the appearance update
                        updateAppearance()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(
                            .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)
                        ) {
                            showFilters.toggle()
                        }
                    } label: {
                        Image(
                            systemName: showFilters
                            ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
                        )
                        .contentTransition(.symbolEffect(.replace.offUp))
                        .foregroundColor(Color(.systemOrange))
                        .shadow(
                            color: Color(.systemOrange), radius: 10,
                            x: 0, y: 0)
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
                        .foregroundColor(Color(.systemPink))
                        .shadow(
                            color: Color(.systemPink), radius: 10,
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
