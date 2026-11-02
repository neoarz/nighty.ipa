import SwiftUI

struct RootView: View {
    @Environment(Session.self) private var session

    var body: some View {
        GeometryReader { proxy in
            if let credentials = session.credentials, let url = credentials.dashboardURL {
                DashboardView(url: url, credentials: credentials, bottomInset: proxy.safeAreaInsets.bottom)
            } else {
                SettingsView(mode: .welcome)
            }
        }
    }
}

#Preview {
    RootView()
        .environment(Session())
}
