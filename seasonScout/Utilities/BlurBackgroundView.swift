import SwiftUI

// A SwiftUI wrapper for adding a UIKit-based blur effect
struct BlurBackgroundView: UIViewRepresentable {
    var style: UIBlurEffect.Style  // The blur style (e.g., light, dark, extra light)

    // Creates and configures the initial `UIVisualEffectView`
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    // Updates the blur effect when the style changes
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
