import SwiftUI
import SwiftUIIntrospect

// A custom view that allows tracking of the scroll view's offset to update the navbar appearance.
struct NavBarOffsetView<Content: View>: UIViewControllerRepresentable {

    @Binding
    private var scrollViewOffset: CGFloat  // Binding to track the scroll view's offset

    private let start: CGFloat  // Start offset to begin fading the navbar
    private let end: CGFloat  // End offset where navbar is fully visible
    private let content: () -> Content  // Content to display

    // Initializer for views where you want to track the scroll offset and adjust navbar visibility
    init(
        scrollViewOffset: Binding<CGFloat>, start: CGFloat, end: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._scrollViewOffset = scrollViewOffset
        self.start = start
        self.end = end
        self.content = content
    }

    // Fallback initializer when no scroll offset is needed
    init(
        start: CGFloat, end: CGFloat, @ViewBuilder body: @escaping () -> Content
    ) {
        self._scrollViewOffset = Binding(get: { 0 }, set: { _ in })
        self.start = start
        self.end = end
        self.content = body
    }

    // Creates the custom Hosting Controller to handle navigation bar adjustments
    func makeUIViewController(context: Context)
        -> NavBarOffsetHostingController<Content>
    {
        NavBarOffsetHostingController(rootView: content())
    }

    // Updates the UIViewController when the scroll view offset changes
    func updateUIViewController(
        _ uiViewController: NavBarOffsetHostingController<Content>,
        context: Context
    ) {
        uiViewController.scrollViewDidScroll(
            scrollViewOffset, start: start, end: end)
    }
}

// Custom HostingController to manage the navbar blur and title color change based on scroll offset
class NavBarOffsetHostingController<Content: View>: UIHostingController<Content>
{

    private var lastScrollViewOffset: CGFloat = 0  // Store the last scroll offset

    private lazy var navBarBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(
            effect: UIBlurEffect(style: .systemThinMaterial))  // Blur effect for the navbar
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = nil

        view.addSubview(navBarBlurView)  // Add the blur view to the navbar
        navBarBlurView.alpha = 0  // Start with invisible blur

        // Set up constraints for the blur view
        NSLayoutConstraint.activate([
            navBarBlurView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarBlurView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarBlurView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            navBarBlurView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
        ])
    }

    // Update navbar based on the scroll offset, fading title and blur
    func scrollViewDidScroll(_ offset: CGFloat, start: CGFloat, end: CGFloat) {
        let diff = end - start
        let currentProgress = (offset - start) / diff
        let offset = min(max(currentProgress, 0), 1)

        // Adjust navbar title color based on scroll progress
        self.navigationController?.navigationBar
            .titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.label
                    .withAlphaComponent(offset)
            ]
        navBarBlurView.alpha = offset  // Adjust blur effect opacity
        lastScrollViewOffset = offset
    }

    // Restore custom NavigationBar state when this view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar
            .titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.label
                    .withAlphaComponent(lastScrollViewOffset)
            ]
        self.navigationController?.navigationBar.setBackgroundImage(
            UIImage(), for: .default)  // Make navbar transparent
        self.navigationController?.navigationBar.shadowImage = UIImage()  // Remove shadow
    }

    // Restore default NavigationBar behavior when leaving the view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]  // Reset title color
        self.navigationController?.navigationBar.setBackgroundImage(
            nil, for: .default)  // Reset background
        self.navigationController?.navigationBar.shadowImage = nil  // Reset shadow image
    }
}

// ViewModifier to apply the navbar offset effect to a view
struct NavBarOffsetModifier: ViewModifier {

    @Binding
    var scrollViewOffset: CGFloat

    let start: CGFloat  // Start scroll offset
    let end: CGFloat  // End scroll offset

    func body(content: Content) -> some View {
        // Adds NavBarOffsetView to the content, modifying navbar based on scroll offset
        NavBarOffsetView(
            scrollViewOffset: $scrollViewOffset, start: start, end: end
        ) {
            content
        }
        .ignoresSafeArea()  // Prevents navbar overlap
    }
}

extension View {
    // Helper method to apply the navbar offset modifier to a view
    func navBarOffset(
        _ scrollViewOffset: Binding<CGFloat>, start: CGFloat, end: CGFloat
    ) -> some View {
        self.modifier(
            NavBarOffsetModifier(
                scrollViewOffset: scrollViewOffset, start: start, end: end))
    }
}

// ViewModifier to track the scroll view offset
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
        content.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18)) {
            scrollView in
            scrollView.delegate = scrollViewDelegate  // Set custom delegate for scroll view
        }
    }

    private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {

        var parent: ScrollViewOffsetModifier?

        // Track the scroll offset as the user scrolls
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent?.scrollViewOffset = scrollView.contentOffset.y
        }
    }
}

extension View {
    // Helper method to apply the scroll view offset modifier to a view
    func scrollViewOffset(_ scrollViewOffset: Binding<CGFloat>) -> some View {
        self.modifier(
            ScrollViewOffsetModifier(scrollViewOffset: scrollViewOffset))
    }
}
