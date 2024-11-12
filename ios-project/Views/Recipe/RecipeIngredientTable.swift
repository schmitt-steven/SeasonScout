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
    
    @State var personCounter = 2
        
    var body: some View {
        
        HStack {
            Text("Personen: \(personCounter)")
            Button("Decrease") {
                personCounter -= personCounter - 1 > 0 ? 1 : 0
            }
            Button("Increase") {
                personCounter += personCounter + 1 < 11 ? 1 : 0
            }
        }
        VStack {
            ForEach( ingredientList[personCounter].ingredients, id: \.id) { ingredient in
                HStack {
                    Text(ingredient.amount)
                    Text(ingredient.name)
                }
                
            }
        }
    }
}

#Preview {
    let rec = Recipe.recipes[199]
    RecipeIngredientTable(ingredientList: rec.ingredientsByPersons)
}
