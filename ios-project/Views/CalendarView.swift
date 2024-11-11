//
//  CalendarView.swift
//  ios-project
//

import SwiftUI

struct CalendarView: View {
    let currentMonth = DateFormatter.monthFormatter.string(from: Date())
    @State private var searchText = ""
    @State private var selectedMonth: String? = nil
    @State private var showOnlyFruits = false
    @State private var showOnlyVegetables = false
    @State private var excludeImports = true
    @State private var showingFilterSheet = false
    
    
    init() {
        _selectedMonth = State(initialValue: DateFormatter.monthFormatter.string(from: Date()))
    }
    
    let fruitsAndVegetables = [
        FruitVegetable(name: "Apfel", emoji: "🍏", availability: [
            MonthAvailability(month: "September", availabilityType: .Regional),
            MonthAvailability(month: "Oktober", availabilityType: .Regional),
            MonthAvailability(month: "November", availabilityType: .Lagerverfügbarkeit)
        ], category: .fruit),
        FruitVegetable(name: "Erdbeere", emoji: "🍓", availability: [
            MonthAvailability(month: "Juni", availabilityType: .Regional),
            MonthAvailability(month: "Juli", availabilityType: .Regional)
        ], category: .fruit),
        FruitVegetable(name: "Banane", emoji: "🍌", availability: [
            MonthAvailability(month: "Import", availabilityType: .Import)
        ], category: .fruit),
        FruitVegetable(name: "Karotte", emoji: "🥕", availability: [
            MonthAvailability(month: "Juli", availabilityType: .Regional),
            MonthAvailability(month: "August", availabilityType: .Regional),
            MonthAvailability(month: "September", availabilityType: .Lagerverfügbarkeit),
            MonthAvailability(month: "Oktober", availabilityType: .Lagerverfügbarkeit)
        ], category: .vegetable),
        FruitVegetable(name: "Birne", emoji: "🍐", availability: [
            MonthAvailability(month: "August", availabilityType: .Regional),
            MonthAvailability(month: "September", availabilityType: .Regional),
            MonthAvailability(month: "Oktober", availabilityType: .Regional)
        ], category: .fruit),
        FruitVegetable(name: "Tomate", emoji: "🍅", availability: [
            MonthAvailability(month: "Juli", availabilityType: .Regional),
            MonthAvailability(month: "August", availabilityType: .Regional),
            MonthAvailability(month: "September", availabilityType: .Regional),
            MonthAvailability(month: "Oktober", availabilityType: .Lagerverfügbarkeit)
        ], category: .vegetable),
        FruitVegetable(name: "Kartoffel", emoji: "🥔", availability: [
            MonthAvailability(month: "Juni", availabilityType: .Regional),
            MonthAvailability(month: "Juli", availabilityType: .Regional),
            MonthAvailability(month: "August", availabilityType: .Regional),
            MonthAvailability(month: "September", availabilityType: .Lagerverfügbarkeit),
            MonthAvailability(month: "Oktober", availabilityType: .Lagerverfügbarkeit),
            MonthAvailability(month: "November", availabilityType: .Lagerverfügbarkeit)
        ], category: .vegetable),
        FruitVegetable(name: "Zucchini", emoji: "🥒", availability: [
            MonthAvailability(month: "Juni", availabilityType: .Regional),
            MonthAvailability(month: "Juli", availabilityType: .Regional),
            MonthAvailability(month: "August", availabilityType: .Regional),
            MonthAvailability(month: "September", availabilityType: .Lagerverfügbarkeit)
        ], category: .vegetable),
        FruitVegetable(name: "Kirsche", emoji: "🍒", availability: [
            MonthAvailability(month: "Juni", availabilityType: .Regional),
            MonthAvailability(month: "Juli", availabilityType: .Regional)
        ], category: .fruit)
    ]
    
    var filteredFruitsAndVegetables: [FruitVegetable] {
        return fruitsAndVegetables.filter { item in
            // Filter nach Suchtext
            let matchesSearchText = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            
            // Filter nach Obst oder Gemüse
            let matchesFruitOrVegetable = (!showOnlyFruits || item.category == .fruit) && (!showOnlyVegetables || item.category == .vegetable)
            
            // Filter nach Importware
            let matchesImport: Bool
            if excludeImports {
                matchesImport = item.availability.contains { $0.availabilityType != .Import }
            } else {
                matchesImport = true
            }
            
            // Filter nach Monat
            let matchesMonth = selectedMonth == nil || item.availability.contains { availability in
                if availability.availabilityType == .Import {
                    return true // Importware wird immer angezeigt, unabhängig vom Monat
                } else {
                    return availability.month == selectedMonth
                }
            }
            
            return matchesSearchText && matchesFruitOrVegetable && matchesImport && matchesMonth
        }
    }
    
    // Funktion zur Filterung der Verfügbarkeit für den aktuellen oder ausgewählten Monat
    func availabilityForSelectedMonth(_ item: FruitVegetable) -> MonthAvailability? {
        // Falls ein Monat ausgewählt ist, diesen verwenden, sonst den aktuellen Monat
        let month = selectedMonth ?? currentMonth
        
        // Prüfen, ob es eine Verfügbarkeit für den ausgewählten Monat gibt
        return item.availability.first { availability in
            availability.month == month || availability.availabilityType == .Import
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Suche nach Obst und Gemüse", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredFruitsAndVegetables) { item in
                            HStack {
                                Text(item.emoji)
                                    .font(.largeTitle)
                                    .padding(.trailing, 10)
                                
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    if let availability = availabilityForSelectedMonth(item) {
                                        AvailabilityView(availability: availability)
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color.white)
            }
            .background(Color.white)
            .navigationBarTitle(selectedMonth ?? currentMonth, displayMode: .inline)
            .navigationBarItems(
                leading: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                },
                trailing: Button(action: {
                    showingFilterSheet.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .imageScale(.large)
                }
            )
            .sheet(isPresented: $showingFilterSheet) {
                VStack {
                    Text("Filter")
                        .font(.headline)
                        .padding()
                    
                    // Monatsauswahl
                    Menu {
                        ForEach(["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"], id: \.self) { month in
                            Button(month) {
                                selectedMonth = month
                            }
                        }
                    } label: {
                        Text(selectedMonth ?? "Monat auswählen")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    // Nur Obst anzeigen / Nur Gemüse anzeigen
                    Toggle("Nur Obst anzeigen", isOn: $showOnlyFruits)
                        .onChange(of: showOnlyFruits) { oldValue, newValue in
                            if newValue {
                                showOnlyVegetables = false
                            }
                        }
                        .padding()
                    
                    Toggle("Nur Gemüse anzeigen", isOn: $showOnlyVegetables)
                        .onChange(of: showOnlyVegetables) { oldValue, newValue in
                            if newValue {
                                showOnlyFruits = false
                            }
                        }
                        .padding()
                    
                    // Keine Importware anzeigen
                    Toggle("Keine Importware anzeigen", isOn: $excludeImports)
                        .padding()
                    
                    Button("Zurück") {
                        showingFilterSheet.toggle()
                    }
                    .font(.headline)
                    .padding()
                }
                .padding()
            }
            
        }
    }
}
