//
//  ExpandableGroupBoxView.swift
//  ios-project
//
//  Created by Henry Harder on 25.11.24.
//

import SwiftUI

struct ExpandableGroupBox<Content: View>: View {
    let title: String
    @State private var isExpanded: Bool = true
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header mit Titel und Chevron
            Button(action: {
                withAnimation(
                    .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)
                ) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    Image(systemName: "chevron.up")
                        .fontWeight(.bold)
                        .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 5)
                .padding(.vertical, 8)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 25)
            
            // Expandierbarer Inhalt
            if isExpanded {
                GroupBox {
                    content()
                }
                .transition(.asymmetric(insertion: .scale(scale: 1.0, anchor: .top),
                                        removal: .opacity))
                .animation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.5), value: isExpanded)
            }
        }
    }
}
