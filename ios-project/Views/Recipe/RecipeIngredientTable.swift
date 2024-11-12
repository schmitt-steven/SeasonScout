//
//  RecipeIngredientTable.swift
//  ios-project
//
//  Created by Poimandres on 11.11.24.
//

import SwiftUI

struct RecipeIngredientTable: View {
    
    let ingredientList: [PersonsIngredients]
    let isRecipeForGroups: Bool = false
    
    @State var personCounter = 3
    var personIndex: Int {
        personCounter - 1
    }
        
    var body: some View {
        
        HStack {
            Text("Personen: \(personCounter)")
            Button("- 1") {
                personCounter -= personCounter - 1 > 0 ? 1 : 0
            }
            Button("+ 1") {
                personCounter += personCounter + 1 < 11 ? 1 : 0
            }
        }
        VStack {
            ForEach(ingredientList[personIndex].ingredients, id: \.id) { ingredient in
                HStack {
                    Text(ingredient.amount)
                    Text(ingredient.name)
                }
                
            }
        }
    }
}

#Preview {
    let rec = Recipe.recipes[1]
    RecipeIngredientTable(ingredientList: rec.ingredientsByPersons)
}
