import SwiftUI

// Represents a single month in the selection view, with gradient animation when selected
struct MonthView: View {
    let month: Month
    let isSelected: Bool
    let onTap: () -> Void
    @State var gradientOpacity: Double

    // Initializes the MonthView with the provided month, selection status, and tap action
    init(month: Month, isSelected: Bool, onTap: @escaping () -> Void) {
        self.month = month
        self.isSelected = isSelected
        self.onTap = onTap
        self.gradientOpacity = isSelected ? 1.0 : 0.0
    }

    var body: some View {
        Text(month.rawValue.prefix(3))  // Display the first 3 letters of the month name
            .font(.headline)
            .padding(.horizontal, 18)
            .padding(.vertical, 6)
            .background(
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        .init(0, 0), .init(0.5, 0), .init(1, 0),
                        .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                        .init(0, 1), .init(0.5, 1), .init(1, 1),
                    ],
                    colors: [
                        .red.opacity(gradientOpacity),
                        .red.opacity(gradientOpacity),
                        .orange.opacity(gradientOpacity),
                        .orange.opacity(gradientOpacity),
                        .red.opacity(gradientOpacity),
                        .orange.opacity(gradientOpacity),
                        .yellow.opacity(gradientOpacity),
                        .orange.opacity(gradientOpacity),
                        .yellow.opacity(gradientOpacity),
                    ])
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture(perform: onTap)
            .onChange(of: isSelected) {
                Task {
                    // Animate the gradient opacity when the selection changes
                    await animateGradientOpacity(
                        to: isSelected ? 1.0 : 0.0, duration: 0.6)
                }
            }
            .id(month)
    }

    // Animates the opacity of the gradient from the current value to the target value
    private func animateGradientOpacity(
        to targetOpacity: Double, duration: TimeInterval
    ) async {
        let steps = 60  // Frames per second
        let interval = duration / Double(steps)
        let delta = (targetOpacity - gradientOpacity) / Double(steps)

        for _ in 0..<steps {
            gradientOpacity += delta
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))  // Sleep for the frame duration
        }

        gradientOpacity = targetOpacity
    }
}

// View for selecting a month, with automatic scrolling to the selected month
struct MonthSelectionView: View {
    @Binding var selectedMonth: Month

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                MonthListView(selectedMonth: $selectedMonth)
                    .scrollTargetLayout()
            }
            .padding(.horizontal, 16)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .onAppear {
                // Scroll automatically to the selected month when the view appears
                scrollProxy.scrollTo(selectedMonth, anchor: .center)
            }
            .onChange(of: selectedMonth) {
                withAnimation(.smooth(duration: 1)) {
                    // Scroll smoothly to the selected month when it changes
                    scrollProxy.scrollTo(selectedMonth, anchor: .center)
                }
            }
        }
    }
}

// Displays a list of all months, with each month wrapped in a MonthView
struct MonthListView: View {
    @Binding var selectedMonth: Month

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Month.allCases, id: \.self) { month in
                MonthView(
                    month: month,
                    isSelected: month == selectedMonth,
                    onTap: {
                        withAnimation(.smooth(duration: 1)) {
                            selectedMonth = month  // Update the selected month when tapped
                        }
                    }
                )
            }
        }
    }
}
