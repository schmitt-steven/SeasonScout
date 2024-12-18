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
        VStack(alignment: .leading) {
            PersonCounterSwitcher(personCounter: $personCounter)
            
            VStack(alignment: .leading, spacing: 7) {
                let allIngredients = ingredientsGroupedByAmount()
                
                ForEach(allIngredients.indices, id: \.self) { index in
                    let ingredient = allIngredients[index]
                    IngredientRow(name: ingredient.name, amount: ingredient.amount)
                    
                    if index < allIngredients.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }
    
    private func ingredientsGroupedByAmount() -> [(name: String, amount: String)] {
        let allIngredients = ingredientList[0].ingredients.enumerated().map { index, ingredient in
            (name: ingredient.name, amount: ingredientList[personIndex].ingredients[index].amount)
        }
        
        let withAmount = allIngredients.filter { !$0.amount.isEmpty }
        let withoutAmount = allIngredients.filter { $0.amount.isEmpty }
        
        return withAmount + withoutAmount
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
            HStack(spacing: 0) {
                Button(action: decrementPerson) {
                    Image(systemName: "minus")
                        .bold()
                        .foregroundStyle(personCounter == minPerson ? .gray : .red)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }
                

                Text("\(personCounter)")
                    .fontWeight(.medium)
                    .fixedSize(horizontal: true, vertical: false)
                    .transition(.blurReplace)

                Button(action: incrementPerson) {
                    Image(systemName: "plus")
                        .bold()
                        .foregroundStyle(personCounter == maxPerson ? .gray : .green)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }
                
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
        withAnimation(){
            personCounter = min(personCounter + 1, maxPerson)
        }
    }
    
    private func decrementPerson() {
        withAnimation(){
            personCounter = max(personCounter - 1, minPerson)
        }
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
