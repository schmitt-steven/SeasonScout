//
//  searchResultsNotification.swift
//  ios-project
//
//  Created by Poimandres on 29.11.24.
//

import SwiftUI

struct SearchResultsNotification: View {
    
    let viewController: MapViewController
    var isMarketListEmpty: Bool {
        viewController.marketsFoundInUserRegion.count == 0
    }
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: isMarketListEmpty ? "exclamationmark.circle" : "checkmark.circle")
                        .foregroundStyle(.orange)
                    Text(isMarketListEmpty ? "Keine Ergebnisse" : "^[\(viewController.marketsFoundInUserRegion.count) Ergebnisse](inflect: true)")
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
