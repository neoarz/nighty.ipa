import Foundation

struct Credentials: Hashable {
    var domain = ""
    var username = ""
    var password = ""

    var dashboardURL: URL? {
        guard
            let url = URL(string: "https://\(normalizedDomain)", encodingInvalidCharacters: false),
            url.host()?.isEmpty == false
        else { return nil }
        return url
    }

    var isComplete: Bool {
        !username.isEmpty && !password.isEmpty && dashboardURL != nil
    }

    private var normalizedDomain: String {
        domain
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacing(#/^https?:\/\//#.ignoresCase(), with: "")
            .replacing(#/\/+$/#, with: "")
    }
}
