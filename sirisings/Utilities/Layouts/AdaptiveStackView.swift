import SwiftUI

struct AdaptiveStack<Content: View>: View {
    
    enum SmallSize {
        case hStack, vStack, defaultStack
    }
    
    @EnvironmentObject var viewManager: ViewManager
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private let checkPortrait: Bool
    private let smallStack: SmallSize
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let spacing: CGFloat?
    private let content: () -> Content
    
    init(checkPortrait: Bool = false, smallStack: SmallSize = .defaultStack, horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.checkPortrait = checkPortrait
        self.smallStack = smallStack
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        Group {
            if sizeClass == .compact {
                if smallStack == .hStack {
                    HStack(alignment: verticalAlignment, spacing: spacing, content: content)
                } else {
                    VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
                }
            } else {
                if smallStack == .hStack || (checkPortrait && viewManager.orientation == .portrait)  {
                    VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
                } else {
                    HStack(alignment: verticalAlignment, spacing: spacing, content: content)
                }
            }
        }
    }
}
