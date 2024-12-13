//
//  searchResultsNotification.swift
//  ios-project
//
//  Created by Poimandres on 29.11.24.
//

import SwiftUI

struct SearchResultsNotification: View {
    
    let viewController: MapViewModel
    var isMarketListEmpty: Bool {
        viewController.shownMapItems.count == 0
    }
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: isMarketListEmpty ? "exclamationmark.circle" : "checkmark.circle")
                        .foregroundStyle(.orange)
                    Text(isMarketListEmpty ? "Keine Ergebnisse" : "^[\(viewController.shownMapItems.count) Ergebnisse](inflect: true)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thickMaterial)
                    .shadow(radius: 6)
            )
            Spacer()
        }
        
    }
}
