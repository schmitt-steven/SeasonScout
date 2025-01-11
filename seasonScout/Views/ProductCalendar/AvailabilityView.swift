import SwiftUI

/// A view that displays the availability status of a product for a given month.
/// It shows a symbol and the availability type (e.g., available, unavailable) with a corresponding color.
struct AvailabilityView: View {
    let availability: SeasonalData  // The availability data for a product in a specific month

    var body: some View {
        HStack {
            HStack {
                // Display an icon representing the availability status
                Image(
                    systemName: symbolForAvailabilityType(
                        availability.availability)
                )
                .foregroundColor(
                    textColorForAvailabilityType(availability.availability))

                Text(availability.availability.rawValue)
                    .font(.subheadline)
                    .foregroundColor(
                        textColorForAvailabilityType(availability.availability))
            }
            .padding(.top, 6)
            .padding(.bottom, 6)
            .padding(.leading, 18)
            .padding(.trailing, 18)
            .background(
                RoundedRectangle(cornerRadius: 8)  // Add rounded corners to the background
                    .fill(
                        backgroundColorForAvailabilityType(
                            availability.availability))  // Fill the background with the appropriate color based on availability
            )
        }
    }
}
