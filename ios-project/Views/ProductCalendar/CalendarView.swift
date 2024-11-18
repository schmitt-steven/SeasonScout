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
    
    @State private var searchText = ""
    @State private var selectedMonth = Month.allCases[Calendar.current.component(.month, from: Date()) - 1]
    @State private var selectedProductType: SelectedProductType = .all
    @State private var excludeNotRegionally = true
    @State private var showFilters = false

    var filteredProducts: [Product] {
        ProductFilter.filter(
            items: Product.products,
            searchText: searchText,
            selectedProductType: selectedProductType,
            excludeNotRegionally: excludeNotRegionally,
            selectedMonth: selectedMonth
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    withAnimation {
                        showFilters.toggle()
                    }
                }) {
                    HStack {
                        Text(showFilters ? "Filter ausblenden" : "Filter anzeigen")
                            .font(.headline)
                        Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                            .font(.headline)
                    }
                    .foregroundColor(.orange)
                }
                .padding()
                
                if showFilters {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(Month.allCases, id: \.self) { month in
                                Text(String(month.rawValue.prefix(1)))
                                    .font(.headline)
                                    .frame(width: 30, height: 30)
                                    .background(
                                        Circle()
                                            .fill(month == selectedMonth ? .orange : .gray.opacity(0.1))
                                    )
                                    .foregroundColor(.black)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedMonth = month
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    
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
            .searchable(text: $searchText, prompt: "Suche nach Produkten")
            .navigationTitle("Kalender")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.orange)
                    }
                    .contextMenu {
                        Button {
                            excludeNotRegionally.toggle()
                        } label: {
                            Label(
                                excludeNotRegionally ? "Überregionale Produkte anzeigen" : "Regionale Produkte anzeigen",
                                systemImage: excludeNotRegionally ? "globe" : "map"
                            )
                        }
                    }
                }
            }
        }
    }
}
