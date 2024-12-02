//
//  HeartSplashView.swift
//  ios-project
//
//  Created by Henry Harder on 28.11.24.
//

import SwiftUI

struct HeartSplashView: View {

    var body: some View {
        ZStack {
            ForEach(0..<8) {
                Circle()
                    .foregroundStyle(Color(.systemPink))
                    .frame(width: 3, height: 3)
                    .offset(x: 24)
                    .rotationEffect(.degrees(Double($0) * 45))
                    .hueRotation(.degrees(270))
            }

            ForEach(0..<8) {
                Circle()
                    .foregroundStyle(Color(.systemPink))
                    .frame(width: 4, height: 4)
                    .offset(x: 26)
                    .rotationEffect(.degrees(Double($0) * 45))
                    .hueRotation(.degrees(0))

            }
            .rotationEffect(.degrees(12))
        }
    }
}

#Preview {
    HeartSplashView()
        .preferredColorScheme(.dark)
}
