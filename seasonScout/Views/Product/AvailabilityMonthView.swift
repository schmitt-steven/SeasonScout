import SwiftUI

/// A view that displays the availability information for a product across different months.
struct AvailabilityMonthView: View {
    let product: Product
    let selectedMonth: Month
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme

    var body: some View {
        let isLightMode = colorScheme == .light
        ScrollViewReader { scrollProxy in
            // Horizontal scroll view to navigate through months
            ScrollView(.horizontal) {
                HStack(spacing: 32) {
                    // Loop through all months and display their availability
                    ForEach(Month.allCases, id: \.self) { month in
                        // Get the availability data for the current month
                        let availability = seasonalDataForMonth(month)?
                            .availability
                        GroupBox {
                            VStack {
                                Text(month.rawValue)
                                    .font(.title.bold())
                                    .padding(.bottom, 5)
                                HStack {
                                    // Availability icon based on the availability type
                                    HStack {
                                        Image(
                                            systemName:
                                                symbolForAvailabilityType(
                                                    availability!)
                                        )
                                        .foregroundStyle(
                                            availability != nil
                                                ? textColorForAvailabilityType(
                                                    availability!)
                                                : Color.black)
                                    }
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(
                                                backgroundColorForAvailabilityType(
                                                    availability!))
                                    )
                                    // Display availability type (or a default message)
                                    Text(
                                        availability?.rawValue
                                            ?? "Nicht identifizierbar"
                                    )
                                    .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .containerRelativeFrame(
                            .horizontal
                        )
                        // Animation during scrolling transition
                        .scrollTransition { content, phase in
                            let brightnessValue = isLightMode ? -0.05 : 0.05

                            return
                                content
                                .opacity(phase.value == 0 ? 1 : 0.95)
                                .offset(x: phase.value * -20)
                                .brightness(phase.value == 0 ? 0 : brightnessValue)
                        }
                        .id(month)  // Set the scroll target ID to the month for easier navigation
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()  // Disable clipping for better scrolling performance
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .onAppear {
                // Automatically scroll to the selected month when the view appears
                scrollProxy.scrollTo(selectedMonth, anchor: .center)
            }
        }
    }

    private func seasonalDataForMonth(_ month: Month) -> SeasonalData? {
        return product.seasonalData.first(where: { $0.month == month })
    }
}

#Preview {
    AvailabilityMonthView(product: Product.products[2], selectedMonth: .nov)
}
