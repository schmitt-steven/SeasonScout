
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
    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}
