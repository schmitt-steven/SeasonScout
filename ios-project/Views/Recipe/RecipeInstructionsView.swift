import SwiftUI

struct RecipeInstructionsView: View {
    
    let instructions: String
    
    // Split instructions into steps based on sentences
    var instructionsAsSteps: [String] {
        instructions.split(separator: ".").map { String($0).trimmingCharacters(in: .whitespaces) }
    }
    
    // Computed property to initialize checkbox states
    @State var checkedSteps: [Bool] = []
    @State var isInStepsMode = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Button(action: {
                withAnimation(.linear(duration: 0.5)) {
                    
                    isInStepsMode.toggle()
                    if checkedSteps.isEmpty {
                        checkedSteps = Array(repeating: false, count: instructionsAsSteps.count)
                    }
                }
            }){
                Text(isInStepsMode ? "Als Fließtext anzeigen" : "Als Schrittfolge anzeigen")
                    .font(.headline).padding(.bottom, 1)
            }
            
            
            if isInStepsMode {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(instructionsAsSteps.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.interpolatingSpring(duration: 0.5)) {
                                checkedSteps[index].toggle()
                            }
                        }) {
                            HStack(alignment: .firstTextBaseline) {
                                Image(systemName: checkedSteps[index] ? "checkmark.square" : "square")
                                    .transition(.scale)
                                
                                Text(instructionsAsSteps[index])
                                    .multilineTextAlignment(.leading)
                            }
                            .foregroundStyle(checkedSteps[index] ? .green : .black)
                        }
                    }
                }
                .transition(.blurReplace)
            } else {
                Text(instructions).transition(.blurReplace)
            }
        }
    }
}

#Preview {
    RecipeInstructionsView(instructions: "lroerwsjf hslekr.s trsk tjbed. sdkfhjhjkdf. gr djskgh .df gdfsjgk hdfhgj .fdg jgk jhesh ejhf. rtjdhjkghkjdkjgehjkrjfhkd .s ewgrjkh . erthje")
}
