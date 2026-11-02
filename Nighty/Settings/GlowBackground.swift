import SwiftUI
import UIKit

struct GlowBackground: View {
    private static let image = UIImage(named: "glow.webp")

    var body: some View {
        if let image = Self.image {
            GeometryReader { proxy in
                ZStack {
                    glow(image, in: proxy.size)
                    glow(image, in: proxy.size)
                        .opacity(0.5)
                }
            }
            .ignoresSafeArea()
        }
    }

    private func glow(_ image: UIImage, in size: CGSize) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size.width * 2, height: size.height * 2)
            .position(x: size.width * 0.25, y: size.height * 0.15)
            .blendMode(.overlay)
    }
}
