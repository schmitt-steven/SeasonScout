//
//  TestRecipeInstructionsView.swift
//  ios-project
//

import SwiftUI

struct TestRecipeInstructionsView: View {
    let instructions: String
    
    var instructionsAsSteps: [String] {
        instructions.split(separator: ".").map { String($0).trimmingCharacters(in: .whitespaces) }
    }
    
    @State var checkedSteps: [Bool] = []
    @State var isInStepsMode = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Umschalter zwischen Fließtext und Schrittfolge
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isInStepsMode.toggle()
                    if checkedSteps.isEmpty {
                        checkedSteps = Array(repeating: false, count: instructionsAsSteps.count)
                    }
                }
            }) {
                Text(isInStepsMode ? "Als Fließtext anzeigen" : "Als Schrittfolge anzeigen")
                    .font(.headline)
                    .padding(.bottom, 1)
                    .foregroundStyle(.orange)
            }
            .padding(.vertical, 5)
            
            if isInStepsMode {
                // Schritt-für-Schritt-Modus
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(instructionsAsSteps.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.interpolatingSpring(duration: 0.5)) {
                                checkedSteps[index].toggle()
                            }
                        }) {
                            HStack(alignment: .firstTextBaseline) {
                                Image(systemName: checkedSteps[index] ? "checkmark.circle" : "circle")
                                    .transition(.scale)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(checkedSteps[index] ? .orange : .primary)
                                
                                // Schritt-Text mit Durchstreichung bei Abhaken
                                Text(instructionsAsSteps[index])
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(checkedSteps[index] ? .black.opacity(0.2) : .black)
                            }
                        }
                        if index != instructionsAsSteps.count - 1 {
                            Divider()
                        }
                    }
                }
                .transition(.blurReplace)
            } else {
                // Fließtext-Modus
                Text(instructions).transition(.blurReplace)
            }
        }
        .padding()
    }
}

#Preview {
    TestRecipeInstructionsView(instructions: "Schritt 1: Zutaten abwiegen. Schritt 2: Den Teig kneten. Schritt 3: Den Teig ruhen lassen. Schritt 4: Den Backofen vorheizen. Schritt 5: Den Teig backen.")
}
