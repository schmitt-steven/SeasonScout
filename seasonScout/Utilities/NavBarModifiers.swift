//
//  NavBarModifiers.swift
//  ios-project
//
//  Created by Poimandres on 23.11.24.
//


import SwiftUI
import SwiftUIIntrospect

struct NavBarOffsetView<Content: View>: UIViewControllerRepresentable {
    
    @Binding
    private var scrollViewOffset: CGFloat
    
    private let start: CGFloat
    private let end: CGFloat
    private let content: () -> Content
    
    init(scrollViewOffset: Binding<CGFloat>, start: CGFloat, end: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self._scrollViewOffset = scrollViewOffset
        self.start = start
        self.end = end
        self.content = content
    }
    
    init(start: CGFloat, end: CGFloat, @ViewBuilder body: @escaping () -> Content) {
        self._scrollViewOffset = Binding(get: { 0 }, set: { _ in })
        self.start = start
        self.end = end
        self.content = body
    }
    
    func makeUIViewController(context: Context) -> NavBarOffsetHostingController<Content> {
        NavBarOffsetHostingController(rootView: content())
    }
    
    func updateUIViewController(_ uiViewController: NavBarOffsetHostingController<Content>, context: Context) {
        uiViewController.scrollViewDidScroll(scrollViewOffset, start: start, end: end)
    }
}

class NavBarOffsetHostingController<Content: View>: UIHostingController<Content> {
    
    private var lastScrollViewOffset: CGFloat = 0
    
    private lazy var navBarBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = nil
        
        view.addSubview(navBarBlurView)
        navBarBlurView.alpha = 0
        
        NSLayoutConstraint.activate([
            navBarBlurView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarBlurView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func scrollViewDidScroll(_ offset: CGFloat, start: CGFloat, end: CGFloat) {
        let diff = end - start
        let currentProgress = (offset - start) / diff
        let offset = min(max(currentProgress, 0), 1)
        
        self.navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(offset)]
        navBarBlurView.alpha = offset
        lastScrollViewOffset = offset
    }
    
    // Restore custom NavigationBar state
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(lastScrollViewOffset)]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
  
    // Restore default NavigationBar for other views
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
}

struct NavBarOffsetModifier: ViewModifier {
    
    @Binding
    var scrollViewOffset: CGFloat
    
    // Begin fading in navbar at offset. If offset < start, navbar hidden
    let start: CGFloat
    // End fading in navbar at offset. If offset > end, navbar shown
    let end: CGFloat
    
    func body(content: Content) -> some View {
        // Required .ignoresSafeArea() due to bug where view will hide under blank NavigationBar
        NavBarOffsetView(scrollViewOffset: $scrollViewOffset, start: start, end: end) {
            content
        }
        .ignoresSafeArea()
    }
}

extension View {
    func navBarOffset(_ scrollViewOffset: Binding<CGFloat>, start: CGFloat, end: CGFloat) -> some View {
        self.modifier(NavBarOffsetModifier(scrollViewOffset: scrollViewOffset, start: start, end: end))
    }
}

struct ScrollViewOffsetModifier: ViewModifier {
    
    @Binding
    var scrollViewOffset: CGFloat
    
    private let scrollViewDelegate: ScrollViewDelegate?
    
    init(scrollViewOffset: Binding<CGFloat>) {
        self._scrollViewOffset = scrollViewOffset
        self.scrollViewDelegate = ScrollViewDelegate()
        self.scrollViewDelegate?.parent = self
    }
    
    func body(content: Content) -> some View {
        content.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18)) { scrollView in
            scrollView.delegate = scrollViewDelegate
        }
    }
    
    private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
        
        var parent: ScrollViewOffsetModifier?
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent?.scrollViewOffset = scrollView.contentOffset.y
        }
    }
}

extension View {
    func scrollViewOffset(_ scrollViewOffset: Binding<CGFloat>) -> some View {
        self.modifier(ScrollViewOffsetModifier(scrollViewOffset: scrollViewOffset))
    }
}
