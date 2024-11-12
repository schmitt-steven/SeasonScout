//
//  ExpandableContainerView.swift
//  ios-project
//
//  Created by Poimandres on 08.11.24.
//

import SwiftUI

struct ExpandableContainer<Content: View>: View {
    
    let title: String
    let content: Content
    let contentPaddingValue: CGFloat
    
    @State private var isExpanded: Bool = true
    
    // Enables trailing closures to embed content, see preview for example
    init(title: String, contentPadding: CGFloat = CGFloat(20), @ViewBuilder content: () -> Content) {
        self.title = title
        self.contentPaddingValue = contentPadding
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation(.smooth) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .imageScale(.medium)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, isExpanded ? CGFloat(2) : CGFloat(15))
            }
            
            if isExpanded {
                content.padding([.bottom, .horizontal], contentPaddingValue)
            }
        }
        .background(.gray)
        .clipShape(.rect(cornerRadius: 15))
        .padding([.leading, .trailing], 20)
        .shadow(color: .gray, radius: 2)
    }
}

#Preview {
    ExpandableContainer(title: "Title") {
        RecipeInstructionsView(instructions: "sdf. sdlfkjdfklgjhksdfkjlg. fgkjdhfg. sgdfg.")
    }
}
