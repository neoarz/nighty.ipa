import SwiftUI

extension Font {
    enum Metropolis: String {
        case thin = "Metropolis-Thin"
        case regular = "Metropolis-Regular"
        case semibold = "Metropolis-SemiBold"
    }

    static func metropolis(_ face: Metropolis, size: CGFloat) -> Font {
        .custom(face.rawValue, size: size)
    }
}
