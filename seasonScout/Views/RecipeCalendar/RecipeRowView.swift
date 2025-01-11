import SwiftUI

/// A view that displays a single recipe in a row with an image, title, and availability for the selected month.
struct RecipeRowView: View {
    let recipe: Recipe // The recipe to display
    @Binding var selectedMonth: Month // Binding for the selected month (used to filter seasonal availability)

    var body: some View {
        // A navigation link that navigates to the RecipeInfoView when tapped
        NavigationLink(destination: RecipeInfoView(recipe: recipe, selectedMonth: selectedMonth)) {
            GroupBox {
                VStack {
                    HStack {
                        // Recipe image displayed in a square frame
                        Image(uiImage: UIImage(named: recipe.imageName)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped() // Ensures the image fits within the bounds of the frame
                            .cornerRadius(8) // Adds rounded corners to the image
                            .foregroundStyle(.secondary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            // Recipe title with bold font
                            Text(recipe.title)
                                .font(.headline.bold())
                                .padding(.bottom, 5)
                            
                            // Seasonal availability for the selected month
                            if let seasonalData = seasonalDataForSelectedMonth() {
                                RecipeAvailabilityView(availability: seasonalData)
                            } else {
                                // If no availability data is found for the selected month, display a fallback message
                                Text("Nicht verfügbar im \(selectedMonth.rawValue)")
                                    .font(.subheadline)
                                    .foregroundColor(Color(UIColor.systemGroupedBackground))
                            }
                        }
                        Spacer()
                    }
                }
            }
            // Gesture to detect horizontal swipe to change months
            .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local).onEnded { value in
                // Only detect horizontal swipes, not vertical ones
                if abs(value.translation.width) > abs(value.translation.height) {
                    if value.translation.width < 0 {
                        // Swipe left - change to the next month
                        MonthSwitcherService.changeMonth(selectedMonth: $selectedMonth, direction: .next)
                    } else {
                        // Swipe right - change to the previous month
                        MonthSwitcherService.changeMonth(selectedMonth: $selectedMonth, direction: .previous)
                    }
                }
            })
        }
        .buttonStyle(PlainButtonStyle()) // Prevents the default navigation link styles
    }

    // Function to check if the recipe is available for the selected month
    private func seasonalDataForSelectedMonth() -> RecipeSeasonalMonthData? {
        return recipe.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
