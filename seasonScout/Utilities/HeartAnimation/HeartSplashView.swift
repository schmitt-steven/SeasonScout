//
//  HeartSplashView.swift
//  ios-project
//
//  Created by Henry Harder on 28.11.24.
//

import SwiftUI

// A view that creates a heart-themed splash animation
struct HeartSplashView: View {

    var body: some View {
        ZStack {
            // Outer layer of circles with pink color and rotation
            ForEach(0..<8) {
                Circle()
                    .foregroundStyle(Color(.systemPink)) // Pink color for circles
                    .frame(width: 3, height: 3) // Circle size
                    .offset(x: 24) // Distance from center
                    .rotationEffect(.degrees(Double($0) * 45)) // Circular arrangement
                    .hueRotation(.degrees(270)) // Color hue adjustment
            }

            // Inner layer of circles with different size and rotation
            ForEach(0..<8) {
                Circle()
                    .foregroundStyle(Color(.systemPink))
                    .frame(width: 4, height: 4)
                    .offset(x: 26)
                    .rotationEffect(.degrees(Double($0) * 45))
                    .hueRotation(.degrees(0))
            }
            .rotationEffect(.degrees(12)) // Additional rotation for inner circles
        }
    }
}

#Preview {
    HeartSplashView()
        .preferredColorScheme(.dark) // Sets the preview to use a dark color scheme
}
