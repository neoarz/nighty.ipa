import ImageIO
import SwiftUI
import os

struct AnimatedImage: View {
    private let url: URL?

    @State private var frame: CGImage?

    init(gifNamed name: String) {
        url = Bundle.main.url(forResource: name, withExtension: "gif")
    }

    var body: some View {
        Color.clear
            .overlay {
                if let frame {
                    Image(decorative: frame, scale: 1)
                        .resizable()
                }
            }
            .task(id: url) {
                guard let url else { return }
                for await image in CGImage.animationFrames(at: url) {
                    frame = image
                }
            }
    }
}

private extension CGImage {
    nonisolated static func animationFrames(at url: URL) -> AsyncStream<CGImage> {
        AsyncStream { continuation in
            let isFinished = OSAllocatedUnfairLock(initialState: false)
            continuation.onTermination = { _ in
                isFinished.withLock { $0 = true }
            }
            let status = CGAnimateImageAtURLWithBlock(url as CFURL, nil) { _, image, stop in
                if isFinished.withLock({ $0 }) {
                    stop.pointee = true
                } else {
                    continuation.yield(image)
                }
            }
            if status != noErr {
                continuation.finish()
            }
        }
    }
}
