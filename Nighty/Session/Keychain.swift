import Foundation
import Security

struct Keychain {
    let service: String

    func string(for account: String) throws(KeychainError) -> String? {
        var query = baseQuery(for: account)
        query[kSecReturnData] = true
        query[kSecMatchLimit] = kSecMatchLimitOne

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else { return nil }
        try KeychainError.check(status)
        return (result as? Data).flatMap { String(bytes: $0, encoding: .utf8) }
    }

    func set(_ value: String, for account: String) throws(KeychainError) {
        let data = Data(value.utf8)
        let updateStatus = SecItemUpdate(
            baseQuery(for: account) as CFDictionary,
            [kSecValueData: data] as CFDictionary
        )
        guard updateStatus == errSecItemNotFound else {
            try KeychainError.check(updateStatus)
            return
        }

        var item = baseQuery(for: account)
        item[kSecValueData] = data
        item[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlock
        try KeychainError.check(SecItemAdd(item as CFDictionary, nil))
    }

    func removeValue(for account: String) throws(KeychainError) {
        let status = SecItemDelete(baseQuery(for: account) as CFDictionary)
        guard status != errSecItemNotFound else { return }
        try KeychainError.check(status)
    }

    private func baseQuery(for account: String) -> [CFString: Any] {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
    }
}

struct KeychainError: Error {
    let status: OSStatus

    static func check(_ status: OSStatus) throws(KeychainError) {
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }
}
