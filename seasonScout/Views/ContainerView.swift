//
//  ContainerView.swift
//  ios-project
//
//  Created by Poimandres on 21.11.24.
//

import SwiftUI

struct ContainerView<Content: View>: View {
    
    let title: String
    let content: Content
    let contentPaddingValue: CGFloat
        
    // Enables trailing closures to embed content, see preview for example
    init(title: String, contentPadding: CGFloat = CGFloat(20), @ViewBuilder content: () -> Content) {
        self.title = title
        self.contentPaddingValue = contentPadding
        self.content = content()
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
            
                content
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(contentPaddingValue)
                .background(Color(.lightestGray))
                .clipShape(.rect(cornerRadius: 15))
                .padding([.leading, .trailing], 20)
                .shadow(color: Color(.systemGray3), radius: 4)
        }
        
    }
}

#Preview {
    ContainerView(title: "Title") {
        RecipeInstructionsView(instructions: "sdf. sdlfkjdfklgjhksdfkjlg. fgkjdhfg. sgdfg.")
    }
}
