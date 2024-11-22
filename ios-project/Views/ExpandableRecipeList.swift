import SwiftUI

struct ExpandableRecipeList: View {
    
    let title: String
    let product: Product
    @State private var currentMonth = Month.allCases[Calendar.current.component(.month, from: Date()) - 1]
    
    // Filtered recipes based on product name in ingredients
    var filteredRecipes: [Recipe] {
        Recipe.recipes.filter { recipe in
            recipe.ingredientsByPersons.flatMap { $0.ingredients }
                .contains { $0.name.contains(product.name) }
        }
    }
    
    @State private var isExpanded = true
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .imageScale(.medium)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
            }
            
            Group {
                if isExpanded {
                    // Scrollable list of recipes with a max height limit
                    ScrollView(.vertical) {
                        VStack {
                            ForEach(filteredRecipes.prefix(5)) { recipe in // Show only first 5 recipes, or adjust as needed
                                NavigationLink(destination: RecipeInfoView(recipe: recipe, selectedMonth: currentMonth)) {
                                    RecipeCardView(recipe: recipe)
                                        .padding([.leading, .trailing], 20)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color(UIColor.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding([.leading, .trailing], 20)
        .shadow(color: .gray, radius: 2)
    }
}

struct RecipeCardView: View {
    
    let recipe: Recipe
    @State private var currentMonth = Month.allCases[Calendar.current.component(.month, from: Date()) - 1]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.title)
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(.black)
            
            Text(recipe.description)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
            
            HStack {
                Text("Aufwand: \(recipe.effort.rawValue)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("Preis: \(recipe.price.rawValue)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top, 5)
            
            NavigationLink(destination: RecipeInfoView(recipe: recipe, selectedMonth: currentMonth)) {
                Text("Zum Rezept")
                    .font(.body)
                    .foregroundColor(.blue)
                    .padding(.top, 8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.vertical, 5)
    }
}

struct ExpandableRecipeList_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product.products[44]
        ExpandableRecipeList(title: "Rezepte", product: product)
    }
}
