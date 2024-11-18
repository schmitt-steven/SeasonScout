import SwiftUI

struct SimilarProductView: View {
    
    let shownProduct: Product
    let productsOfSameSubtype: [Product]
    
    init(shownProduct: Product) {
        self.shownProduct = shownProduct
        self.productsOfSameSubtype = Product.products.compactMap { product in
            return product.subtype.rawValue == shownProduct.subtype.rawValue && product.id != shownProduct.id ? product : nil
        }
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(productsOfSameSubtype, id: \.id) { product in
                    Button(action: {
                        // TODO: Navigate to the selected product's detail view
                    }) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.systemGray5))
                                .frame(width: 150, height: 200)
                        
                            VStack {
                                Text(ProductEmojis.emoji(forProduct: product.name))
                                    .padding()
                                    .font(.system(size: 100))
                                
                                Text(product.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 5)
                                    .padding(.bottom, 20)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 20)
        }
    }
}

#Preview {
    let product = Product.products[44] // Example product
    SimilarProductView(shownProduct: product)
}
