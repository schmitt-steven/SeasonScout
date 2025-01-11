import SwiftUI
import WrappingHStack

/// A view that represents a single recipe tag with an icon and text.
struct RecipeTagView: View {
    // The symbol to display next to the tag text (icon).
    let symbol: String

    // The title text of the tag.
    let title: String

    // The background color of the tag.
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

/// A section view displaying a list of tags for a recipe using a wrapping stack layout.
struct RecipeTagsSection: View {
    // List of tag data to be displayed in the section.
    @State var tagDataList: [InfoTag]

    var body: some View {
        WrappingHStack(
            tagDataList, id: \.self, alignment: .leading, spacing: .constant(5),
            lineSpacing: 7
        ) { tagData in
            switch tagData.type {
            case .forGroups:
                let isForGroups = tagData.value as! Bool
                RecipeTagView(
                    symbol: isForGroups ? "person.badge.plus" : "person",
                    title: isForGroups
                        ? "Für Gruppen" : "Ungeeignet für Gruppen",
                    backgroundColor: .black)
            case .isVegetarian:
                let isVegetarian = tagData.value as! Bool
                RecipeTagView(
                    symbol: "fork.knife.circle.fill",
                    title: isVegetarian ? "Vegetarisch" : "Nicht vegetarisch",
                    backgroundColor: isVegetarian ? .green : .red)
            case .priceLevel:
                let priceLevel = tagData.value as! Level
                switch priceLevel {
                case .low:
                    RecipeTagView(
                        symbol: "eurosign.circle.fill", title: "Geringer Preis",
                        backgroundColor: .gray)
                case .medium:
                    RecipeTagView(
                        symbol: "eurosign.circle.fill",
                        title: "Mittlerer Preis", backgroundColor: .gray)
                case .high:
                    RecipeTagView(
                        symbol: "eurosign.circle.fill", title: "Hoher Preis",
                        backgroundColor: .gray)
                }
            case .effortLevel:
                let effortLevel = tagData.value as! Level
                switch effortLevel {
                case .low:
                    RecipeTagView(
                        symbol: "clock.fill", title: "Geringer Aufwand",
                        backgroundColor: Color(.systemIndigo))
                case .medium:
                    RecipeTagView(
                        symbol: "clock.fill", title: "Mittlerer Aufwand",
                        backgroundColor: Color(.systemIndigo))
                case .high:
                    RecipeTagView(
                        symbol: "clock.fill", title: "Hoher Aufwand",
                        backgroundColor: Color(.systemIndigo))
                }
            case .recipeCategory:
                RecipeTagView(
                    symbol: "tag.fill", title: tagData.value as! String,
                    backgroundColor: Color(.systemBlue))
            }
        }
    }
}
