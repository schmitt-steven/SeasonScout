import SwiftUI

struct RecipeIngredientTable: View {
    
    let ingredientList: [PersonsIngredients]
    let minAmountColumnWidth = CGFloat(60)
    @State private var personCounter = 3
    
    private var personIndex: Int {
        personCounter - 1
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            PersonCounterSwitcher(personCounter: $personCounter)
            
            VStack(alignment: .leading, spacing: 5) {
                Divider()
                ForEach(displayIngredientsWithAmount(), id: \.offset) { index, name in
                    IngredientRow(name: name, amount: ingredientList[personIndex].ingredients[index].amount)
                   
                }
                
                ForEach(displayIngredientsWithoutAmount(), id: \.offset) { index, name in
                    IngredientRow(name: name, amount: "")
                }
            }
        }
    }
    
    
    private func displayIngredientsWithAmount() -> [(offset: Int, element: String)] {
        ingredientList[0].ingredients.enumerated()
            .filter { index, _ in
                !ingredientList[personIndex].ingredients[index].amount.isEmpty
            }
            .map { (offset: $0.offset, element: $0.element.name) }
    }
    
    private func displayIngredientsWithoutAmount() -> [(offset: Int, element: String)] {
        ingredientList[0].ingredients.enumerated()
            .filter { index, _ in
                ingredientList[personIndex].ingredients[index].amount.isEmpty
            }
            .map { (offset: $0.offset, element: $0.element.name) }
    }
}

struct PersonCounterSwitcher: View {
    @Binding var personCounter: Int
    private let minPerson = 1
    private let maxPerson = 10
    
    var body: some View {
        HStack {
            Text("Für")
            HStack {
                Button(action: decrementPerson) {
                    Image(systemName: "minus")
                        .bold()
                        .foregroundStyle(personCounter == minPerson ? .gray : .red)
                }
                
                Text("\(personCounter)")
                    .fontWeight(.medium)
                
                Button(action: incrementPerson) {
                    Image(systemName: "plus")
                        .bold()
                        .foregroundStyle(personCounter == maxPerson ? .gray : .green)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 1)
            
            Text("Personen")
        }
        .padding(.vertical, 5)
    }
    
    private func incrementPerson() {
        personCounter = min(personCounter + 1, maxPerson)
    }
    
    private func decrementPerson() {
        personCounter = max(personCounter - 1, minPerson)
    }
}

struct IngredientRow: View {
    let name: String
    let amount: String
    let minAmountColumnWidth = CGFloat(60)
    
    var body: some View {
        HStack(alignment: .top) {
            Text(amount.isEmpty ? " " : amount)
                .frame(minWidth: minAmountColumnWidth, alignment: .trailing)
                .font(.callout)
                .fontWeight(.medium)
            Text(name)
                .fontWeight(.regular)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
        Divider()
    }
}

#Preview {
    let rec = Recipe.recipes[7]
    RecipeIngredientTable(ingredientList: rec.ingredientsByPersons)
}
