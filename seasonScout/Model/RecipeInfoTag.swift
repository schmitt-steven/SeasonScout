import SwiftUI

struct InfoTag: Identifiable {
    let id = UUID()
    let type: InfoTagType
    let value: Any  // Tag values can be in Enum, String or Bool form
}
