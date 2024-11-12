//
//  RecipeInfoTag.swift
//  ios-project
//
//  Created by Poimandres on 07.11.24.
//

import SwiftUI

struct InfoTag: Identifiable {
    let id = UUID()
    let type: InfoTagType
    let value: Any  // Tag values can be in Enum, String or Bool form
}
