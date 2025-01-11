import SwiftUI

/// A view that displays a single product in a row, including its image, name, botanical name, and availability.
struct ProductRowView: View {
    let product: Product
    @Binding var selectedMonth: Month  // Binding to the selected month to filter availability

    var body: some View {
        // NavigationLink allows the user to tap on a row and navigate to a detailed product view
        NavigationLink(
            destination: ProductInfoView(
                product: product, selectedMonth: selectedMonth)
        ) {
            GroupBox {
                VStack {
                    HStack {
                        // If the product has no image, display a placeholder
                        if product.imageName.isEmpty {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.secondary)
                        } else {
                            // If the product has an image, display it
                            Image(uiImage: UIImage(named: product.imageName)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(8)
                                .foregroundStyle(.secondary)
                        }

                        // Text content for product name, botanical name, and availability
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.name)
                                .font(.headline.bold())

                            Text(product.botanicalName)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 5)

                            // Display availability if data exists, otherwise show "not available" message
                            if let seasonalData = seasonalDataForSelectedMonth()
                            {
                                AvailabilityView(availability: seasonalData)
                            } else {
                                Text(
                                    "Nicht verfügbar im \(selectedMonth.rawValue)"
                                )
                                .font(.subheadline)
                                .foregroundColor(
                                    Color(UIColor.systemGroupedBackground))
                            }
                        }
                        Spacer()
                    }
                }
            }
            // Detect swiping gesture to change the month
            .gesture(
                DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onEnded { value in

                        // Only change month on a horizontal swipe, not a vertical one
                        if abs(value.translation.width)
                            > abs(value.translation.height)
                        {
                            if value.translation.width < 0 {
                                // Swipe left to change to next month
                                MonthSwitcherService.changeMonth(
                                    selectedMonth: $selectedMonth,
                                    direction: .next)
                            } else {
                                // Swipe right to change to previous month
                                MonthSwitcherService.changeMonth(
                                    selectedMonth: $selectedMonth,
                                    direction: .previous)
                            }
                        }

                    })
        }
        .buttonStyle(PlainButtonStyle())
    }

    // Funktion zur Prüfung der Verfügbarkeit des Produkts im aktuellen Monat
    private func seasonalDataForSelectedMonth() -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == selectedMonth })
    }
}
