//
//  RecipeFilterView.swift
//  ios-project
//
//  Created by Henry Harder on 19.11.24.
//

import SwiftUI

struct RecipeFilterView: View {
    @Binding var selectedRecipeCategory: RecipeCategory?
    @Binding var selectedRecipeEffort: Level?
    @Binding var selectedRecipePrice: Level?
    @Binding var selectedRecipeIsFavorite: Bool
    @Binding var selectedRecipeIsForGroups: Bool
    @Binding var selectedRecipeIsVegetarian: Bool

    var body: some View {
        List {
            Section {
                Picker("Kategorie", selection: $selectedRecipeCategory) {
                    Text("Alle").tag(nil as RecipeCategory?)
                    ForEach(RecipeCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category as RecipeCategory?)
                    }
                }.pickerStyle(.navigationLink)

                Picker("Aufwand", selection: $selectedRecipeEffort) {
                    Text("egal").tag(nil as Level?)
                    ForEach(Level.allCases, id: \.self) { effort in
                        Text(effort.rawValue).tag(effort as Level?)
                    }
                }.pickerStyle(.navigationLink)

                Picker("Kosten", selection: $selectedRecipePrice) {
                    Text("egal").tag(nil as Level?)
                    ForEach(Level.allCases, id: \.self) { price in
                        Text(price.rawValue).tag(price as Level?)
                    }
                }.pickerStyle(.navigationLink)
            }
            Section {
                NavigationLink(
                    destination: ToggleView(
                        isOn: $selectedRecipeIsFavorite, title: "Nur Favoriten",
                        footer:
                            "Beachte, dass nur die Favoriten des ausgewählten Monats angezeigt werden."
                    )
                ) {
                    HStack {
                        Text("Nur Favoriten")
                        Spacer()
                        Text(selectedRecipeIsFavorite ? "Ja" : "Nein")
                            .foregroundStyle(Color.gray)
                    }
                }

                NavigationLink(
                    destination: ToggleView(
                        isOn: $selectedRecipeIsForGroups,
                        title: "Für Gruppen",
                        footer:
                            "Beachte, dass nur die Rezepte für Gruppen des ausgewählten Monats angezeigt werden."
                    )
                ) {
                    HStack {
                        Text("Für Gruppen")
                        Spacer()
                        Text(selectedRecipeIsForGroups ? "Ja" : "Nein")
                            .foregroundStyle(Color.gray)
                    }
                }

                NavigationLink(
                    destination: ToggleView(
                        isOn: $selectedRecipeIsVegetarian,
                        title: "Vegetarisch",
                        footer:
                            "Beachte, dass nur die vegetarischen Rezepte des ausgewählten Monats angezeigt werden."
                    )
                ) {
                    HStack {
                        Text("Vegetarisch")
                        Spacer()
                        Text(selectedRecipeIsVegetarian ? "Ja" : "Nein")
                            .foregroundStyle(Color.gray)
                    }
                }
            }

        }
        .navigationTitle("Filter")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ToggleView: View {
    @Binding var isOn: Bool
    var title: String
    var footer: String

    var body: some View {
        List {
            Section(footer: Text(footer)) {
                Toggle(isOn: $isOn) {
                    Text(title)
                }
            }
        }
        .navigationTitle(title)
    }
}
