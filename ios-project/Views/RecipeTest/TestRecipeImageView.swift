//
//  TestRecipeImageView.swift
//  ios-project
//

import SwiftUI

struct TestRecipeImageView: View {
    let recipe: Recipe
    @State private var isFlipped = false

    var body: some View {
        Image(
            uiImage: UIImage(named: recipe.imageName)!
        )
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .shadow(color: .black, radius: 2)
            .overlay(
                Group {
                    if isFlipped {
                        // Rückseite
                        Rectangle()
                            .fill(.black)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Informationen zur Seite")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            Text(
                                "Rezeptinformationen und Bilder stammen von der Webseite regional-saisonal.de"
                            )
                            .foregroundColor(.white)
                        }
                        .padding()
                        .rotation3DEffect(
                            .degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0)
                        )
                    }
                }
            )
            .onTapGesture {
                isFlipped.toggle()
            }
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0)
            )
            .animation(.default, value: isFlipped)
    }
}

#Preview {
    TestRecipeImageView(recipe: Recipe.recipes[5])
}
