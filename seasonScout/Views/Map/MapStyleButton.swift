//
//  MapStyleButton.swift
//  SeasonScout
//
//  Created by Poimandres on 12.12.24.
//

import SwiftUI


struct MapStyleButton: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                Button(action: {
                    viewModel.changeMapStyle()
                }) {
                    viewModel.currentMapStyle.1
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                        .padding(.all, 12)
                        .foregroundStyle(Color(.systemOrange))
                        .background(BlurBackgroundView(style: .systemThickMaterial))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.trailing, -12)
                .padding(.top, -20)
            }
            .padding(.trailing, 0)
            Spacer()
        }
        .padding()
    }
}

