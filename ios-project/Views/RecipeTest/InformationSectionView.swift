//
//  InformationSectionView.swift
//  ios-project
//
//  Created by Henry Harder on 26.11.24.
//

import SwiftUI

struct InformationSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // Abstand optimiert
            Divider()
            
            Text("Informationen zur Seite")
                .font(.title3.bold())
                .foregroundColor(.gray)
            Text("Rezeptinformationen und Bilder stammen von der Webseite regional-saisonal.de")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

