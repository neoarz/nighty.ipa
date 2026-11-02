import SwiftUI

extension Animation {
    static let focus = Animation.spring(response: 0.35, dampingFraction: 0.85)
    static let press = Animation.snappy(duration: 0.2)
}
