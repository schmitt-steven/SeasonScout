//
//  RecipeTagView.swift
//  ios-project
//

import SwiftUI
import WrappingHStack

struct RecipeTagView: View {
    let symbol: String
    let title: String
    let backgroundColor: Color

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .foregroundStyle(.white)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.white)
        }
        .padding(.top, 6)
        .padding(.bottom, 6)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
        )
    }
}

struct RecipeTagsSection: View {
    
    @State var tagDataList: [InfoTag]
    
    var body: some View {
        WrappingHStack(tagDataList, id: \.self, alignment: .leading, spacing: .constant(5), lineSpacing: 7) {tagData in
            switch tagData.type {
            case .forGroups:
                let isForGroups = tagData.value as! Bool
                RecipeTagView(symbol: isForGroups ? "person.badge.plus" : "person", title: isForGroups ? "Für Gruppen" : "Ungeeignet für Gruppen", backgroundColor: .black)
            case .isVegetarian:
                let isVegetarian = tagData.value as! Bool
                RecipeTagView(symbol: "leaf.fill", title: isVegetarian ? "Vegetarisch" : "Nicht vegetarisch", backgroundColor: isVegetarian ? .green : .red)
            case .priceLevel:
                let priceLevel = tagData.value as! Level
                switch priceLevel {
                case .low:
                    RecipeTagView(symbol: "eurosign.circle.fill", title: "Geringer Preis", backgroundColor: .gray)
                case .medium:
                    RecipeTagView(symbol: "eurosign.circle.fill", title: "Mittlerer Preis", backgroundColor: .gray)
                case .high:
                    RecipeTagView(symbol: "eurosign.circle.fill", title: "Hoher Preis",backgroundColor: .gray)
                }
            case .effortLevel:
                let effortLevel = tagData.value as! Level
                switch effortLevel {
                case .low:
                    RecipeTagView(symbol: "clock.fill", title: "Geringer Aufwand", backgroundColor: Color(.systemIndigo))
                case .medium:
                    RecipeTagView(symbol: "clock.fill", title: "Mittlerer Aufwand", backgroundColor: Color(.systemIndigo))
                case .high:
                    RecipeTagView(symbol: "clock.fill", title: "Hoher Aufwand", backgroundColor: Color(.systemIndigo))
                }
            case .recipeCategory:
                RecipeTagView(symbol: "tag.fill", title: tagData.value as! String, backgroundColor: Color(.systemBlue))
            }
        }
    }
}
