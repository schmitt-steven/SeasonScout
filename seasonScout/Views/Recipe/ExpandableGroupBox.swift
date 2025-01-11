import SwiftUI

/// A view that provides a collapsible group with a title and expandable content.
/// The group can be expanded or collapsed when the user taps on the title.
struct ExpandableGroupBox<Content: View>: View {
    let title: String  // Title of the expandable group
    @State private var isExpanded: Bool = true  // State to track if the group is expanded or collapsed
    let content: () -> Content  // Closure to provide the content inside the group box

    var body: some View {
        VStack(alignment: .leading) {
            // Header with title and a chevron indicating expand/collapse
            Button(action: {
                // Toggle the expansion state with an animation when the header is tapped
                withAnimation(
                    .spring(
                        response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)
                ) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    // Title of the group box displayed in bold
                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.primary)

                    // Chevron icon to indicate the expandable nature of the group
                    Image(systemName: "chevron.down")
                        .fontWeight(.bold)
                        .rotationEffect(
                            isExpanded ? .degrees(180) : .degrees(0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 5)
                .padding(.vertical, 8)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 25)

            // Expandable content
            if isExpanded {
                // If the group is expanded, show the content inside a GroupBox
                GroupBox {
                    content()
                }
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 1.0, anchor: .top),
                        removal: .opacity)
                )
                .animation(
                    .spring(
                        response: 0.4, dampingFraction: 0.75, blendDuration: 0.5
                    ), value: isExpanded)
            }
        }
    }
}
