import SwiftUI

struct FloatingButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder let label: Label

    @AppStorage("settingsButtonX") private var savedX: Double?
    @AppStorage("settingsButtonY") private var savedY: Double?
    @State private var dragOrigin: CGPoint?
    @State private var dragPosition: CGPoint?
    @State private var isTouching = false

    private let diameter: CGFloat = 44
    private let margin: CGFloat = 12
    private let dragThreshold: CGFloat = 2

    private var scale: CGFloat {
        if dragOrigin != nil { return 1.1 }
        return isTouching ? 0.9 : 1
    }

    var body: some View {
        GeometryReader { proxy in
            let bounds = proxy.size
            let position = dragPosition ?? clamped(restingPosition(in: bounds), in: bounds)
            label
                .contentShape(.circle)
                .scaleEffect(scale)
                .animation(.press, value: scale)
                .accessibilityElement(children: .ignore)
                .accessibilityAddTraits(.isButton)
                .accessibilityAction(.default, action)
                .position(position)
                .gesture(dragGesture(from: position, in: bounds))
        }
    }

    private func dragGesture(from position: CGPoint, in bounds: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isTouching = true
                if dragOrigin == nil, hypot(value.translation.width, value.translation.height) > dragThreshold {
                    dragOrigin = position
                }
                if let dragOrigin {
                    dragPosition = clamped(dragOrigin.offset(by: value.translation), in: bounds)
                }
            }
            .onEnded { value in
                if let dragOrigin {
                    save(clamped(dragOrigin.offset(by: value.translation), in: bounds))
                } else {
                    action()
                }
                isTouching = false
                dragOrigin = nil
                dragPosition = nil
            }
    }

    private func restingPosition(in bounds: CGSize) -> CGPoint {
        if let savedX, let savedY {
            return CGPoint(x: savedX, y: savedY)
        }
        return CGPoint(x: bounds.width - diameter / 2 - 20, y: diameter + 32)
    }

    private func clamped(_ point: CGPoint, in bounds: CGSize) -> CGPoint {
        let inset = diameter / 2 + margin
        return CGPoint(
            x: min(max(point.x, inset), max(inset, bounds.width - inset)),
            y: min(max(point.y, inset), max(inset, bounds.height - inset))
        )
    }

    private func save(_ point: CGPoint) {
        savedX = point.x
        savedY = point.y
    }
}

private extension CGPoint {
    func offset(by translation: CGSize) -> CGPoint {
        CGPoint(x: x + translation.width, y: y + translation.height)
    }
}
