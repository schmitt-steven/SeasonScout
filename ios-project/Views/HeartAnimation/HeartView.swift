//
//  HeartView.swift
//  ios-project
//
//  Created by Henry Harder on 28.11.24.
//

import SwiftUI

struct HeartView: View {
    @State var isFavorite: Bool
    @State private var showSplash = false
    @State private var removeSplash = false
    @State private var removeInnerStroke = true
    @State private var closeAnimation = false
    
    @State private var showSplash2 = false
    @State private var removeSplash2 = false
    @State private var removeInnerStroke2 = true
    @State private var closeAnimation2 = false

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .strokeBorder(lineWidth: removeInnerStroke ? 0 : 1)
                    .frame(
                        width: 40, height: 40,
                        alignment: .center
                    )
                    .foregroundColor(Color(.systemPink))
                    .scaleEffect(showSplash ? (closeAnimation ? 0 : 1.1) : 0)
                    .opacity(removeSplash ? 0 : 1)
                    .hueRotation(.degrees(removeInnerStroke ? 270 : 0))
                
                Circle()
                    .strokeBorder(lineWidth: removeInnerStroke2 ? 0 : 1)
                    .frame(
                        width: 40, height: 40,
                        alignment: .center
                    )
                    .foregroundColor(Color(.systemPink))
                    .scaleEffect(showSplash2 ? (closeAnimation2 ? 0 : 1) : 0)
                    .opacity(removeSplash2 ? 0 : 1)
                    .hueRotation(.degrees(removeInnerStroke2 ? 270 : 0))
                
                Image(systemName: "heart")
                    .foregroundColor(Color(.systemGray))

                Image(systemName: "heart.fill")
                    .foregroundStyle(Color(.systemPink))
                    .scaleEffect(isFavorite ? 1 : 0)

                HeartSplashView()
                    .scaleEffect(showSplash ? (closeAnimation ? 0 : 0.7) : 0)
                    .opacity(removeSplash ? 0 : 1)

            }
            .onTapGesture {
                withAnimation(
                    .interpolatingSpring(stiffness: 170, damping: 10).delay(0.1)
                ) {
                    isFavorite.toggle()
                }

                withAnimation(.easeOut) {
                    showSplash.toggle()
                }

                withAnimation(.easeIn.delay(0.5)) {
                    removeSplash.toggle()
                }

                withAnimation(.easeIn.delay(0.2)) {
                    removeInnerStroke.toggle()
                }
                
                withAnimation(.easeIn.delay(0.5)) {
                    closeAnimation.toggle()
                }
                
                withAnimation(.easeOut.delay(0.1)) {
                    showSplash2.toggle()
                }

                withAnimation(.easeIn.delay(0.6)) {
                    removeSplash2.toggle()
                }

                withAnimation(.easeIn.delay(0.3)) {
                    removeInnerStroke2.toggle()
                }
                
                withAnimation(.easeIn.delay(0.6)) {
                    closeAnimation2.toggle()
                }
            }.accessibilityAddTraits(.isButton)
        }
    }
}

#Preview {
    HeartView(isFavorite: false)
        .preferredColorScheme(.dark)
}
