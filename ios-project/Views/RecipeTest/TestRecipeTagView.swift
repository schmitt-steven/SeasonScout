//
//  TestRecipeTagView.swift
//  ios-project
//

import SwiftUI
import WrappingHStack

struct TestRecipeTagView: View {
    let symbol: String
    let title: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .foregroundStyle(color)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(color)
        }
        .padding(.top, 6)
        .padding(.bottom, 6)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.2))
        )
    }
}

struct TestRecipeTagsSection: View {
    
    @State var tagDataList: [InfoTag]
    
    var body: some View {
        WrappingHStack(tagDataList, id: \.self, alignment: .leading, spacing: .constant(5), lineSpacing: 7) {tagData in
            switch tagData.type {
            case .forGroups:
                let isForGroups = tagData.value as! Bool
                TestRecipeTagView(symbol: "person.3.fill", title: isForGroups ? "Für Gruppen" : "Ungeeignet für Gruppen", color: isForGroups ? .green : .red)
            case .isVegetarian:
                let isVegetarian = tagData.value as! Bool
                TestRecipeTagView(symbol: "leaf.fill", title: isVegetarian ? "Vegetarisch" : "Nicht vegetarisch", color: isVegetarian ? .green : .red)
            case .priceLevel:
                let priceLevel = tagData.value as! Level
                switch priceLevel {
                case .low:
                    TestRecipeTagView(symbol: "creditcard.fill", title: "Geringer Preis", color: .green)
                case .medium:
                    TestRecipeTagView(symbol: "creditcard.fill", title: "Mittlerer Preis", color: .orange)
                case .high:
                    TestRecipeTagView(symbol: "creditcard.fill", title: "Hoher Preis", color: .red)
                }
            case .effortLevel:
                let effortLevel = tagData.value as! Level
                switch effortLevel {
                case .low:
                    TestRecipeTagView(symbol: "clock.fill", title: "Geringer Aufwand", color: .green)
                case .medium:
                    TestRecipeTagView(symbol: "clock.fill", title: "Mittlerer Aufwand", color: .orange)
                case .high:
                    TestRecipeTagView(symbol: "clock.fill", title: "Hoher Aufwand", color: .red)
                }
            case .recipeCategory:
                TestRecipeTagView(symbol: "tag.fill", title: tagData.value as! String, color: .gray)
            }
        }
    }
}
