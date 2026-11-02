import SwiftUI

struct CardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(LinearGradient(gradient: Palette.cardFill, startPoint: .topTrailing, endPoint: .bottomLeading))
            .strokeBorder(
                LinearGradient(gradient: Palette.cardBorder, startPoint: .top, endPoint: .bottom),
                lineWidth: 1.5
            )
            .shadow(color: .white.opacity(0.03), radius: 0, y: 1)
            .shadow(color: .white.opacity(0.02), radius: 0)
    }
}
