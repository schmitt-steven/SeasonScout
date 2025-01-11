import SwiftUI

struct GlowEffect: ViewModifier {
    var color: Color = .white
    var blurRadius: CGFloat = 1
    var offset: CGSize = CGSize(width: 0.5, height: -0.5)
    var opacity: Double = 0.3

    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .blur(radius: blurRadius)
                    .offset(x: offset.width, y: offset.height)
                    .opacity(opacity)
            )
    }
}

struct InnerShadowEffect: ViewModifier {
    var color: Color = .gray.opacity(0.2)
    var offset: CGSize = CGSize(width: -1, height: -1)

    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .foregroundColor(color)
                    .offset(x: offset.width, y: offset.height)
            )
    }
}

struct TextShadowEffect: ViewModifier {

    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1)
            .shadow(color: .black.opacity(0.6), radius: 4, x: 2, y: 2)
            .shadow(color: .black.opacity(0.4), radius: 8, x: 3, y: 3)
            .shadow(color: .white.opacity(0.2), radius: 12, x: 4, y: 4)
    }
}
