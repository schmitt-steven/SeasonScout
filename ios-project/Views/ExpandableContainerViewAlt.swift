//
//  ExpandableContainerViewAlt.swift
//  ios-project
//
//  Created by Poimandres on 30.11.24.
//

//
//  ContainerView.swift
//  ios-project
//
//  Created by Poimandres on 21.11.24.
//

import SwiftUI

struct ExpandableContainerViewAlt<Content: View>: View {
    
    let title: String
    let content: Content
    let contentPaddingValue: CGFloat
    @State var isExpanded: Bool
        
    // Enables trailing closures to embed content, see preview for example
    init(title: String, contentPadding: CGFloat = CGFloat(20), @ViewBuilder content: () -> Content) {
        self.title = title
        self.contentPaddingValue = contentPadding
        self.content = content()
        self.isExpanded = false
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 5)
            
            VStack{
                if (isExpanded){
                    content
                }
                Button(action: {
                    withAnimation(.smooth) {
                        isExpanded.toggle()
                    }
                }) {
                    Text("\(isExpanded ? "Weniger" : "Mehr") anzeigen")
                        .foregroundStyle(Color(.systemGray2))
                        .shadow(color: Color(.systemGray5), radius: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                       // .padding(.top, isExpanded ? 1 : 0)
                }
            }
            .padding(contentPaddingValue)
            .background(Color(.lightestGray))
            .clipShape(.rect(cornerRadius: 15))
            .padding([.leading, .trailing], 20)
            .shadow(color: Color(.systemGray3), radius: 4)
        }
        
    }
}

#Preview {
    ExpandableContainerViewAlt(title: "Title") {
        RecipeInstructionsView(instructions: "sdf. sdlfkjdfklgjhksdfkjlg. fgkjdhfg. sgdfg.")
    }
}
