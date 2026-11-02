import WebKit

final class AutoLogin: NSObject, WKNavigationDelegate {
    var credentials: Credentials

    private var hasSubmitted = false
    private var pendingAttempt: Task<Void, Never>?

    init(credentials: Credentials) {
        self.credentials = credentials
    }

    func load(_ url: URL, in webView: WKWebView) {
        pendingAttempt?.cancel()
        hasSubmitted = false
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pendingAttempt?.cancel()
        pendingAttempt = Task { [weak webView] in
            do {
                try await Task.sleep(for: .milliseconds(500))
            } catch {
                return
            }
            guard let webView else { return }
            let foundLoginForm = await fillLoginForm(in: webView, submit: !hasSubmitted)
            guard !Task.isCancelled else { return }
            hasSubmitted = foundLoginForm
        }
    }

    private func fillLoginForm(in webView: WKWebView, submit: Bool) async -> Bool {
        let result = try? await webView.callAsyncJavaScript(
            Self.loginScript,
            arguments: [
                "username": credentials.username,
                "password": credentials.password,
                "submit": submit
            ],
            contentWorld: .page
        )
        return result as? Bool ?? false
    }

    private static let loginScript = """
        const usernameInput = document.querySelector('input[name="Username"]');
        const passwordInput = document.querySelector('input[name="Password"]');
        if (!usernameInput || !passwordInput) return false;
        if (!submit) return true;

        usernameInput.value = username;
        passwordInput.value = password;
        usernameInput.dispatchEvent(new Event('input', { bubbles: true }));
        passwordInput.dispatchEvent(new Event('input', { bubbles: true }));
        document.querySelector('button[type="submit"]')?.click();
        return true;
        """
}
