//
//  searchResultsNotification.swift
//  ios-project
//
//  Created by Poimandres on 29.11.24.
//

import SwiftUI

struct SearchResultsNotification: View {
    
    let viewController: MapViewController
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(.orange)
                Text("\(viewController.marketsFoundInUserRegion.count) Ergebnisse")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6).opacity(0.9))
                    .shadow(radius: 6)
            )
            Spacer()
        }
        
    }
}
