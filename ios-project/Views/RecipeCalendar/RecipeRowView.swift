import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    let selectedMonth: Month

    var body: some View {
        NavigationLink(destination: RecipeInfoView(recipe: recipe, selectedMonth: selectedMonth)) {
            GroupBox {
                VStack {
                    HStack {
                        Image(uiImage: UIImage(named: recipe.imageName)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(8)
                            .foregroundStyle(.secondary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(recipe.title)
                                .font(.headline.bold())
                                .padding(.bottom, 5)
                            
                            if let seasonalData = seasonalDataForSelectedMonth() {
                                RecipeAvailabilityView(availability: seasonalData)
                            } else {
                                Text("Nicht verfügbar im \(selectedMonth.rawValue)")
                                    .font(.subheadline)
                                    .foregroundColor(Color(UIColor.systemGroupedBackground))
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Verhindert, dass der Link Standard-Stile anwendet (z.B. Hervorhebung)
    }

    // Funktion zur Prüfung der Verfügbarkeit des Produkts im aktuellen Monat
    private func seasonalDataForSelectedMonth() -> RecipeSeasonalMonthData? {
        return recipe.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
