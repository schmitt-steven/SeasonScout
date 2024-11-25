//
//  RecipeCalenderView.swift
//  ios-project
//
//  Created by Henry Harder on 16.11.24.
//

import SwiftUI

struct RecipeCalendarView: View {
    @State private var searchText = ""
    @State private var selectedMonth = Month.allCases[Calendar.current.component(.month, from: Date()) - 1]
    @State private var excludeNotRegionallyRecipes = true
    @State private var showFilters = false

    var filteredRecipes: [Recipe] {
        RecipeFilter.filter(
            items: Recipe.recipes,
            searchText: searchText,
            excludeNotRegionallyRecipes: excludeNotRegionallyRecipes,
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
                }
                
                Spacer()
                RecipeListView(recipes: filteredRecipes, selectedMonth: selectedMonth)
                Spacer()
            }
            .searchable(text: $searchText, prompt: "Suche nach Rezepten")
            .navigationTitle("")
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
                            excludeNotRegionallyRecipes.toggle()
                        } label: {
                            Label(
                                excludeNotRegionallyRecipes ? "Überregionale Rezepte anzeigen" : "Regionale Rezepte anzeigen",
                                systemImage: excludeNotRegionallyRecipes ? "globe" : "map"
                            )
                        }
                    }
                }
            }
        }
    }
}
