import Foundation
import OSLog

struct CredentialVault {
    private let defaults: UserDefaults
    private let keychain: Keychain
    private let logger = Logger(subsystem: appIdentifier, category: "CredentialVault")

    init(defaults: UserDefaults = .standard, keychain: Keychain = Keychain(service: appIdentifier)) {
        self.defaults = defaults
        self.keychain = keychain
    }

    func load() -> Credentials? {
        guard
            let domain = defaults.string(forKey: Key.domain),
            let username = defaults.string(forKey: Key.username),
            let password = loadPassword()
        else { return nil }
        return Credentials(domain: domain, username: username, password: password)
    }

    func save(_ credentials: Credentials) {
        defaults.set(credentials.domain, forKey: Key.domain)
        defaults.set(credentials.username, forKey: Key.username)
        savePassword(credentials.password)
    }

    func clear() {
        defaults.removeObject(forKey: Key.domain)
        defaults.removeObject(forKey: Key.username)
        defaults.removeObject(forKey: Key.password)
        do {
            try keychain.removeValue(for: Key.password)
        } catch {
            logger.error("Removing the password from the keychain failed with status \(error.status)")
        }
    }

    private func loadPassword() -> String? {
        if let fallback = defaults.string(forKey: Key.password) {
            savePassword(fallback)
            return fallback
        }
        do {
            return try keychain.string(for: Key.password)
        } catch {
            logger.error("Reading the password from the keychain failed with status \(error.status)")
            return nil
        }
    }

    private func savePassword(_ password: String) {
        do {
            try keychain.set(password, for: Key.password)
            defaults.removeObject(forKey: Key.password)
        } catch {
            logger.error("Keychain unavailable with status \(error.status), keeping the password in user defaults")
            defaults.set(password, forKey: Key.password)
        }
    }
}

private let appIdentifier = Bundle.main.bundleIdentifier ?? "Nighty"

private enum Key {
    static let domain = "domain"
    static let username = "username"
    static let password = "password"
}
