//
//  BadInternetConnectionMessage.swift
//  ios-project
//
//  Created by Poimandres on 28.11.24.
//

import SwiftUI

enum MapErrorType{
    case badInternetConnection
    case unexpectedError
}

struct MapViewErrorMessage: View {
    
    @ObservedObject var mapViewController: MapViewModel
    let errorType: MapErrorType
    
    var errorMessage: String {
        switch errorType {
        case .badInternetConnection:
            "Eine Internetverbindung konnte leider nicht hergestellt werden."
        case .unexpectedError:
            "Während der Suche ist ein Fehler aufgetreten."
        }
    }
    
    var errrorSymbol: String {
        switch errorType {
        case .badInternetConnection:
            "wifi.exclamationmark"
        case .unexpectedError:
           "exclamationmark.circle"
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: errrorSymbol)
                        .font(.title)
                        .foregroundStyle(.orange)
                    
                    Text(errorMessage)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(.regularMaterial.shadow(.drop(radius: 4)))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    Task {
                        if let currentLocation = mapViewController.locationManager.location {
                            await mapViewController.searchForMarkets(using: currentLocation)
                        }
                    }
                }) {
                    HStack{
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.accentColor)

                        Text("Erneut versuchen")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.regularMaterial.shadow(.drop(radius: 10)))
                .clipShape(.rect(cornerRadius: 8))

            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
            .shadow(radius: 6)
            Spacer()
        }
        .padding(10)
    }
}
