import SwiftUI
import UIKit
import WebKit

struct DashboardWebView: UIViewRepresentable {
    let url: URL
    let credentials: Credentials

    func makeCoordinator() -> AutoLogin {
        AutoLogin(credentials: credentials)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let background = UIColor(Palette.dashboardBackground)
        webView.isOpaque = false
        webView.backgroundColor = background
        webView.scrollView.backgroundColor = background
        webView.navigationDelegate = context.coordinator
        context.coordinator.load(url, in: webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard context.coordinator.credentials != credentials else { return }
        context.coordinator.credentials = credentials
        context.coordinator.load(url, in: webView)
    }
}
