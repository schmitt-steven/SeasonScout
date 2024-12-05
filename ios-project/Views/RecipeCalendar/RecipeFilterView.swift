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
    @Binding var selectedRecipeIsForGroups: Bool
    @Binding var selectedRecipeIsVegetarian: Bool

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBlue)))
                    
                    Picker("Kategorie", selection: $selectedRecipeCategory) {
                        Text("Alle").tag(nil as RecipeCategory?)
                        ForEach(RecipeCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category as RecipeCategory?)
                        }
                    }.pickerStyle(.navigationLink)
                }

                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemIndigo)))
                    
                    Picker("Aufwand", selection: $selectedRecipeEffort) {
                        Text("egal").tag(nil as Level?)
                        ForEach(Level.allCases, id: \.self) { effort in
                            Text(effort.rawValue).tag(effort as Level?)
                        }
                    }.pickerStyle(.navigationLink)
                }

                HStack {
                    Image(systemName: "eurosign.circle.fill")
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(.gray))
                    
                    Picker("Kosten", selection: $selectedRecipePrice) {
                        Text("egal").tag(nil as Level?)
                        ForEach(Level.allCases, id: \.self) { price in
                            Text(price.rawValue).tag(price as Level?)
                        }
                    }.pickerStyle(.navigationLink)
                }
            }
            Section {
                HStack {
                    Image(systemName: selectedRecipeIsForGroups ? "person.badge.plus" : "person")
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(.black))
                    
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
                                .foregroundStyle(.gray)
                        }
                    }
                }

                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(selectedRecipeIsVegetarian ? .green : .red))
                    
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
