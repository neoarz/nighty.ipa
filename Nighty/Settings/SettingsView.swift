import SwiftUI

struct SettingsView: View {
    enum Mode {
        case welcome
        case editing

        var title: LocalizedStringKey {
            switch self {
            case .welcome: "Welcome Back"
            case .editing: "Settings"
            }
        }
    }

    private enum Field {
        case domain
        case username
        case password
    }

    let mode: Mode

    @State private var draft: Credentials
    @FocusState private var focusedField: Field?
    @Environment(Session.self) private var session
    @Environment(\.dismiss) private var dismiss

    init(mode: Mode, credentials: Credentials = Credentials()) {
        self.mode = mode
        _draft = State(initialValue: credentials)
    }

    private var isTyping: Bool {
        focusedField != nil
    }

    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            GlowBackground()

            VStack(spacing: 0) {
                if mode == .editing {
                    closeButton
                }

                GeometryReader { proxy in
                    ScrollView {
                        content
                            .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .scrollDismissesKeyboard(.interactively)
                    .scrollIndicators(.hidden)
                }
            }
        }
        .contentShape(.rect)
        .onTapGesture {
            focusedField = nil
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            SettingsHeader(title: mode.title)
                .padding(.bottom, 40)
                .frame(height: isTyping ? 0 : nil, alignment: .bottom)
                .clipped()
                .opacity(isTyping ? 0 : 1)
            loginCard
            CreditLink()
                .padding(.top, 30)
        }
        .padding(24)
        .animation(.focus, value: isTyping)
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Palette.text)
                .padding(10)
        }
        .accessibilityLabel("Close")
        .padding(.trailing, 20)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var loginCard: some View {
        VStack(spacing: 24) {
            Text("Login")
                .font(.metropolis(.semibold, size: 18))
                .foregroundStyle(Palette.text)

            FloatingLabelField("Domain", text: $draft.domain, kind: .url, field: .domain, focus: $focusedField)
            FloatingLabelField(
                "Username",
                text: $draft.username,
                kind: .username,
                field: .username,
                focus: $focusedField
            )
            FloatingLabelField(
                "Password",
                text: $draft.password,
                kind: .password,
                field: .password,
                focus: $focusedField
            )

            Button("Continue", action: save)
                .buttonStyle(.primary)
                .disabled(!draft.isComplete)
                .padding(.top, 4)

            if mode == .editing {
                Button("Sign Out", role: .destructive, action: signOut)
                    .buttonStyle(.destructive)
                    .padding(.top, 2)
            }
        }
        .padding(24)
        .background(CardBackground())
        .frame(maxWidth: 500)
        .frame(minHeight: 320)
    }

    private func save() {
        let credentials = draft
        focusedField = nil
        if mode == .editing {
            dismiss()
        }
        Task {
            await session.signIn(with: credentials)
        }
    }

    private func signOut() {
        dismiss()
        Task {
            await session.signOut()
        }
    }
}
