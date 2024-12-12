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
        VStack(alignment: .trailing) {
            HStack(alignment: .top) {
                Spacer()
                Button(action: {
                    viewModel.changeMapStyle()
                }) {
                    viewModel.currentMapStyle.1
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                        .padding(12)
                        .background(BlurBackgroundView(style: .prominent))
                        .clipShape(Circle())
                }
            }
            .padding(.top, 40)
            .padding(.trailing, -10)
            Spacer()
        }
        .padding()
    }
}

