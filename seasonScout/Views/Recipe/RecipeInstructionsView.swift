import SwiftUI

/// A view that displays the instructions for a recipe either as plain text or as steps with checkboxes.
struct RecipeInstructionsView: View {
    let instructions: String

    // Splits the instructions into individual steps based on periods.
    var instructionsAsSteps: [String] {
        instructions.split(separator: ".").map {
            String($0).trimmingCharacters(in: .whitespaces)
        }
    }

    @State var checkedSteps: [Bool] = []  // Tracks which steps are checked
    @State var isInStepsMode = false  // Tracks if the view is in step-by-step mode or plain text mode

    var body: some View {
        VStack(alignment: .leading) {

            // Toggle button to switch between step-by-step and plain text modes
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isInStepsMode.toggle()
                    if checkedSteps.isEmpty {
                        checkedSteps = Array(
                            repeating: false, count: instructionsAsSteps.count)
                    }
                }
            }) {
                Text(
                    isInStepsMode
                        ? "Als Fließtext anzeigen" : "Als Schrittfolge anzeigen"
                )
                .font(.headline)
                .padding(.bottom, 1)
                .foregroundStyle(.orange)
            }
            .padding(.vertical, 5)

            if isInStepsMode {
                // Step-by-step mode
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(instructionsAsSteps.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.interpolatingSpring(duration: 0.5)) {
                                checkedSteps[index].toggle()
                            }
                        }) {
                            HStack(alignment: .firstTextBaseline) {
                                // Checkmark icon
                                Image(
                                    systemName: checkedSteps[index]
                                        ? "checkmark.circle" : "circle"
                                )
                                .transition(.scale)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    checkedSteps[index] ? .orange : .primary)

                                // Instruction text with strikethrough when checked
                                Text(instructionsAsSteps[index])
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(
                                        checkedSteps[index]
                                            ? Color.text.opacity(0.2)
                                            : Color.text)
                            }
                        }
                        if index != instructionsAsSteps.count - 1 {
                            Divider()
                        }
                    }
                }
                .transition(.blurReplace)
            } else {
                // Plain text mode
                Text(instructions).transition(.blurReplace)
            }
        }
        .padding()
    }
}

#Preview {
    RecipeInstructionsView(
        instructions:
            Recipe.recipes[13].instructions
    )
}
