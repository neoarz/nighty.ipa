import SwiftUI

struct NightyButtonStyle: ButtonStyle {
    enum Kind {
        case primary
        case destructive

        var gradient: Gradient {
            switch self {
            case .primary: Palette.primary
            case .destructive: Palette.destructive
            }
        }

        var shadowOpacity: Double {
            switch self {
            case .primary: 0.3
            case .destructive: 0.25
            }
        }
    }

    let kind: Kind

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.metropolis(.semibold, size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                LinearGradient(gradient: kind.gradient, startPoint: .leading, endPoint: .trailing),
                in: .rect(cornerRadius: 12)
            )
            .shadow(color: .black.opacity(kind.shadowOpacity), radius: 10, y: 4)
            .contentShape(.rect(cornerRadius: 12))
            .opacity(isEnabled ? 1 : 0.8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.press, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == NightyButtonStyle {
    static var primary: NightyButtonStyle {
        NightyButtonStyle(kind: .primary)
    }

    static var destructive: NightyButtonStyle {
        NightyButtonStyle(kind: .destructive)
    }
}
