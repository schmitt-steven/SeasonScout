//  RecipeTagSectionView.swift
//  ios-project
//
//  Created by Poimandres on 07.11.24.
//
import SwiftUI
import WrappingHStack

struct RecipeTag: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(5)
            .background(color.opacity(0.9).blur(radius: 1))
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: .gray, radius: 3)
    }
}

struct RecipeTagsSection: View {
    
    @State var tagDataList: [InfoTag]
    
    var body: some View {
        WrappingHStack(tagDataList, id: \.self, alignment: .leading, spacing: .constant(5), lineSpacing: 7) {tagData in
            switch tagData.type {
            case .forGroups:
                let isForGroups = tagData.value as! Bool
                RecipeTag(title: isForGroups ? "Für Gruppen" : "Ungeeignet für Gruppen", color:isForGroups ?  .green: .red)
            case .isVegetarian:
                let isVegetarian = tagData.value as! Bool
                RecipeTag(title: isVegetarian ? "Vegetarisch" : "Nicht vegetarisch", color: isVegetarian ?.green : .red)
            case .priceLevel:
                let priceLevel = tagData.value as! Level
                switch priceLevel {
                case .low:
                    RecipeTag(title: "Geringer Preis", color: .green)
                case .medium:
                    RecipeTag(title: "Mittlerer Preis", color: .orange)
                case .high:
                    RecipeTag(title: "Hoher Preis", color: .red)
                }
            case .effortLevel:
                let effortLevel = tagData.value as! Level
                switch effortLevel {
                case .low:
                    RecipeTag(title: "Geringer Aufwand", color: .green)
                case .medium:
                    RecipeTag(title: "Mittlerer Aufwand", color: .orange)
                case .high:
                    RecipeTag(title: "Hoher Aufwand", color: .red)
                }
            case .recipeCategory:
                RecipeTag(title: tagData.value as! String, color: .gray)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 0)
    }
}
