import SwiftUI

public struct ScrollViewIfNeeded<Content: View>: View {
    
    public var content: Content

    public var axes: Axis.Set

    public var showsIndicators: Bool

    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    @State private var fitsVertically = false

    public var body: some View {
        GeometryReader { geometryReader in
            ScrollView(showsIndicators: showsIndicators) {
                content
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ViewSizeKey.self,
                                value: geometry.frame(in: .local).size
                            )
                        }
                    )
            }
            .onPreferenceChange(ViewSizeKey.self) { pref in
                fitsVertically = pref.height <= geometryReader.size.height
            }
        }
    }

    private struct ViewSizeKey: PreferenceKey {
        static var defaultValue: CGSize { .zero }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            let next = nextValue()
            value = CGSize(
                width: value.width + next.width,
                height: value.height + next.height
            )
        }
    }
}
