import SwiftUI

enum Palette {
    static let background = Color(red: 12 / 255, green: 16 / 255, blue: 27 / 255)
    static let dashboardBackground = Color(red: 21 / 255, green: 26 / 255, blue: 35 / 255)

    static let text = Color(red: 0.81, green: 0.85, blue: 0.94)
    static let placeholder = text.opacity(0.7)
    static let fieldLabel = Color(red: 0.85, green: 0.89, blue: 0.96)
    static let fieldFill = Color(red: 0.22, green: 0.24, blue: 0.29, opacity: 0.27)
    static let fieldFocusRing = Color(red: 0.48, green: 0.61, blue: 0.81, opacity: 0.42)

    static let title = Gradient(colors: [
        Color(red: 0.61, green: 0.69, blue: 0.83),
        Color(red: 0.95, green: 0.95, blue: 1.0)
    ])
    static let primary = Gradient(colors: [
        Color(red: 0.16, green: 0.28, blue: 0.76),
        Color(red: 0.31, green: 0.44, blue: 0.92)
    ])
    static let destructive = Gradient(colors: [
        Color(red: 0.78, green: 0.18, blue: 0.28),
        Color(red: 0.89, green: 0.36, blue: 0.41)
    ])
    static let cardFill = Gradient(colors: [
        Color(red: 0.17, green: 0.19, blue: 0.24, opacity: 0.28),
        Color(red: 0.13, green: 0.15, blue: 0.20, opacity: 0.22)
    ])
    static let cardBorder = Gradient(colors: [
        .white.opacity(0.05),
        .white.opacity(0.02)
    ])
}
