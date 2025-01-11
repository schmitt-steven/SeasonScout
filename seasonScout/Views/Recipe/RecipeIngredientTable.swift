import SwiftUI

/// A view that shows a table of ingredients for a recipe, adjusting the amount of each ingredient based on the number of persons.
struct RecipeIngredientTable: View {
    let ingredientList: [PersonsIngredients]  // The list of ingredients per person count
    let minAmountColumnWidth = CGFloat(60)  // Minimum width for the amount column
    @State private var personCounter: Int = 4  // Default person count

    private var personIndex: Int {
        personCounter - 1
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Person counter switcher to adjust the number of people
            PersonCounterSwitcher(personCounter: $personCounter)

            VStack(alignment: .leading, spacing: 7) {
                // Group ingredients by their amount for easier presentation
                let allIngredients = ingredientsGroupedByAmount()

                ForEach(allIngredients.indices, id: \.self) { index in
                    let ingredient = allIngredients[index]
                    IngredientRow(
                        name: ingredient.name, amount: ingredient.amount)

                    if index < allIngredients.count - 1 {
                        Divider()
                    }
                }
            }

        }
    }

    // Groups ingredients by their amounts based on the selected person count
    private func ingredientsGroupedByAmount() -> [(
        name: String, amount: String
    )] {
        // Fetch the ingredients for the current person count and return them
        let allIngredients = ingredientList.first!.ingredients.enumerated().map
        { index, ingredient in
            (
                name: ingredient.name,
                amount: ingredientList.first(where: {
                    $0.personNumber == personCounter
                })!.ingredients[index].amount
            )
        }

        // Sort by non-empty amounts first, and then by empty amounts
        return allIngredients.sorted { !$0.amount.isEmpty && $1.amount.isEmpty }
    }
}

/// A view that allows the user to switch between different person counts.
struct PersonCounterSwitcher: View {
    @Binding var personCounter: Int
    private let minPerson = 1
    private let maxPerson = 10

    var body: some View {
        HStack {
            Text("Für")
                .padding(.trailing, 5)
            HStack(spacing: 0) {
                // Decrement button
                Button(action: decrementPerson) {
                    Image(systemName: "minus")
                        .bold()
                        .foregroundStyle(
                            personCounter == minPerson ? .gray : .red
                        )
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }

                // Current person counter display
                Text("\(personCounter)")
                    .fontWeight(.medium)
                    .fixedSize(horizontal: true, vertical: false)

                // Increment button
                Button(action: incrementPerson) {
                    Image(systemName: "plus")
                        .bold()
                        .foregroundStyle(
                            personCounter == maxPerson ? .gray : .green
                        )
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }

            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 1)

            // Person text (singular or plural based on the person counter)
            Text(personCounter == 1 ? " Person" : "Personen")
                .padding(.leading, 5)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 5)
    }

    // Increment the person counter, ensuring it doesn't exceed the max value
    private func incrementPerson() {
        withAnimation {
            personCounter = min(personCounter + 1, maxPerson)
        }
    }

    // Decrement the person counter, ensuring it doesn't go below the min value
    private func decrementPerson() {
        withAnimation {
            personCounter = max(personCounter - 1, minPerson)
        }
    }
}

/// A view that shows a row for each ingredient with its name and amount.
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
