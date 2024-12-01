//
//  CalendarView.swift
//  ios-project
//
//  Created by Henry Harder on 14.11.24.
//

import SwiftUI

struct CalendarView: View {
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .orange
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black], for: .selected)
    }
    
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    @State private var searchText = ""
    @State private var selectedMonth = Month.allCases[Calendar.current.component(.month, from: Date()) - 1]
    @State private var selectedProductType: SelectedProductType = .all
    @State private var selectedProductIsFavorite = false
    @State private var excludeNotRegionally = true
    @State private var showFilters = false

    var filteredProducts: [Product] {
        ProductFilter.filter(
            items: Product.products,
            searchText: searchText,
            selectedProductType: selectedProductType,
            selectedProductIsFavorite : selectedProductIsFavorite,
            excludeNotRegionally: excludeNotRegionally,
            selectedMonth: selectedMonth
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                MonthSelectionView(selectedMonth: $selectedMonth)
                
                Button(action: {
                    withAnimation {
                        showFilters.toggle()
                    }
                }) {
                    HStack {
                        Text(showFilters ? "Filter ausblenden" : "Filter anzeigen")
                            .font(.headline)
                            .foregroundColor(isDarkModeEnabled ? .white : .black)
                        Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                            .font(.headline)
                    }
                }
                .padding(.top)
                
                if showFilters {
                    Picker("Wähle ein Produkttyp aus", selection: $selectedProductType){
                        ForEach(SelectedProductType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                Spacer()
                ProductListView(products: filteredProducts, selectedMonth: selectedMonth)
                Spacer()
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Suche nach Produkten")
            .navigationTitle("Kalender")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            excludeNotRegionally.toggle()
                        } label: {
                            Label(
                                excludeNotRegionally ? "Überregionale Produkte anzeigen" : "Überregionale Produkte ausblenden",
                                systemImage: excludeNotRegionally ? "ferry" : "leaf"
                            )
                        }
                        Button {
                            selectedProductIsFavorite.toggle()
                        } label: {
                            Label(
                                selectedProductIsFavorite ? "Favoriten ausblenden" : "Favoriten anzeigen",
                                systemImage: selectedProductIsFavorite ? "heart.slash" : "heart"
                            )
                        }
                    } label: {
                        Label("", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }
}
