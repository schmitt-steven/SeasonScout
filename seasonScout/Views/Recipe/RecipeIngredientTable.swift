import SwiftUI

struct RecipeIngredientTable: View {
    
    let ingredientList: [PersonsIngredients]
    let minAmountColumnWidth = CGFloat(60)
    @State private var personCounter: Int
    
    private var personIndex: Int {
        personCounter - 1
    }
    
    internal init(ingredientList: [PersonsIngredients]) {
        self.ingredientList = ingredientList
        self.personCounter = 4
    }
    
    
    var body: some View {
        let withAmount = ingredientsWithAmount()
        let withoutAmount = ingredientsWithoutAmount()
        
        VStack(alignment: .leading) {
            PersonCounterSwitcher(personCounter: $personCounter)
            
            VStack(alignment: .leading, spacing: 7) {
                ForEach(withAmount, id: \.offset) { index, name in
                    let matchingIngredientsForCounter = ingredientList.first(where: { $0.personNumber == personCounter })
                    IngredientRow(name: name, amount: matchingIngredientsForCounter!.ingredients[index].amount)
                    
                    
                    if index < withAmount.count - 1 || !withoutAmount.isEmpty {
                        Divider()
                    }
                }
                
                ForEach(withoutAmount, id: \.offset) { index, name in
                    IngredientRow(name: name, amount: "")
                    
                    if index < withoutAmount.count - 1 {
                                        Divider()
                                    }
                }
            }
        }
    }
    
    
    private func ingredientsWithAmount() -> [(offset: Int, element: String)] {
        ingredientList[0].ingredients.enumerated()
            .filter { index, _ in
                !ingredientList[personIndex].ingredients[index].amount.isEmpty
            }
            .map { (offset: $0.offset, element: $0.element.name) }
    }
    
    private func ingredientsWithoutAmount() -> [(offset: Int, element: String)] {
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
                .padding(.trailing, 5)
            HStack {
                Button(action: decrementPerson) {
                    Image(systemName: "minus")
                        .bold()
                        .foregroundStyle(personCounter == minPerson ? .gray : .red)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)

                Text("\(personCounter)")
                    .fontWeight(.medium)
                    .fixedSize(horizontal: true, vertical: false)

                Button(action: incrementPerson) {
                    Image(systemName: "plus")
                        .bold()
                        .foregroundStyle(personCounter == maxPerson ? .gray : .green)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 1)
            
            Text(personCounter == 1 ? " Person" : "Personen")
                .padding(.leading, 5)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 5)
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
    }
}

#Preview {
    let rec = Recipe.recipes[7]
    RecipeIngredientTable(ingredientList: rec.ingredientsByPersons)
}