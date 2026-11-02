import SwiftUI

struct DashboardView: View {
    let url: URL
    let credentials: Credentials
    let bottomInset: CGFloat

    @State private var isShowingSettings = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                DashboardWebView(url: url, credentials: credentials)
                Palette.dashboardBackground
                    .frame(height: bottomInset > 0 ? bottomInset : 20)
            }
            .ignoresSafeArea()
            .persistentSystemOverlays(.hidden)

            FloatingButton {
                isShowingSettings = true
            } label: {
                AnimatedImage(gifNamed: "monke")
                    .frame(width: 38, height: 38)
            }
            .accessibilityLabel("Settings")
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isShowingSettings) { _, isShowing in
            isShowing
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView(mode: .editing, credentials: credentials)
                .presentationDragIndicator(.visible)
                .presentationBackground(Palette.background)
        }
    }
}
