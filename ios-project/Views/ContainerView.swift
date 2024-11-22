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
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, CGFloat(2))
            
                content
                .padding(.horizontal, contentPaddingValue)
                .padding(.bottom, max(0, contentPaddingValue - 5))
        }
        .background(Color(.lightestGray))
        .clipShape(.rect(cornerRadius: 15))
        .padding([.leading, .trailing], 20)
        .shadow(color: .gray, radius: 2)
    }
}

#Preview {
    ContainerView(title: "Title") {
        RecipeInstructionsView(instructions: "sdf. sdlfkjdfklgjhksdfkjlg. fgkjdhfg. sgdfg.")
    }
}
