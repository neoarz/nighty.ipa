import SwiftUI

struct SettingsHeader: View {
    let title: LocalizedStringKey

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(.nightyLogo)
                    .resizable()
                    .scaledToFit()
                    .brightness(-0.2)
                    .frame(width: 24, height: 24)
                    .accessibilityHidden(true)
                Text("Nighty")
                    .font(.metropolis(.semibold, size: 20))
                    .tracking(-0.5)
                    .foregroundStyle(LinearGradient(gradient: Palette.title, startPoint: .top, endPoint: .bottom))
            }
            .padding(.bottom, 6)

            Text(title)
                .font(.metropolis(.thin, size: 36))
                .tracking(-1)
                .foregroundStyle(LinearGradient(gradient: Palette.title, startPoint: .bottom, endPoint: .top))
        }
    }
}
