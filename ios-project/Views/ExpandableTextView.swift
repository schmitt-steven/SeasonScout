//
//  ExpandableTextView.swift
//  ios-project
//
//  Created by Poimandres on 07.11.24.
//

import SwiftUI

struct ExpandableTextContainer: View {
    
    let title: String
    let content: String
    
    @State var isExpanded: Bool = true
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.smooth) {
                    isExpanded.toggle()
                }
            }) {
                HStack() {
                    Text(title).font(.headline).foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .imageScale(.medium)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, isExpanded ? CGFloat(2) : CGFloat(15))
                
            }
           
            if isExpanded {
                Text(content).padding([.bottom, .horizontal], 20)
            }
        }
        .background(Color(.lightestGray))
        .clipShape(.rect(cornerRadius: 15))
        .padding([.leading, .trailing], 20)
        .shadow(radius: 2)
    }
}
