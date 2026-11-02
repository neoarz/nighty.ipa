import Observation
import WebKit

@Observable
final class Session {
    private(set) var credentials: Credentials?
    @ObservationIgnored private let vault: CredentialVault

    init(vault: CredentialVault = CredentialVault()) {
        self.vault = vault
        if let stored = vault.load(), stored.isComplete {
            credentials = stored
        }
    }

    func signIn(with newCredentials: Credentials) async {
        if let credentials, credentials != newCredentials {
            await clearWebsiteData()
        }
        vault.save(newCredentials)
        credentials = newCredentials
    }

    func signOut() async {
        await clearWebsiteData()
        vault.clear()
        credentials = nil
    }

    private func clearWebsiteData() async {
        await WKWebsiteDataStore.default().removeData(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
            modifiedSince: .distantPast
        )
    }
}
