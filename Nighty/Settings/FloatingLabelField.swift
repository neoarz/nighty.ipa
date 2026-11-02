import SwiftUI
import UIKit

struct FloatingLabelField<Field: Hashable>: View {
    enum Kind {
        case url
        case username
        case password

        var contentType: UITextContentType {
            switch self {
            case .url: .URL
            case .username: .username
            case .password: .password
            }
        }

        var keyboardType: UIKeyboardType {
            self == .url ? .URL : .default
        }
    }

    private let label: LocalizedStringKey
    @Binding private var text: String
    private let kind: Kind
    private let field: Field
    private let focus: FocusState<Field?>.Binding

    @State private var contentHeight: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let labelScale: CGFloat = 12 / 16

    init(
        _ label: LocalizedStringKey,
        text: Binding<String>,
        kind: Kind,
        field: Field,
        focus: FocusState<Field?>.Binding
    ) {
        self.label = label
        _text = text
        self.kind = kind
        self.field = field
        self.focus = focus
    }

    private var isFocused: Bool {
        focus.wrappedValue == field
    }

    private var isRaised: Bool {
        isFocused || !text.isEmpty
    }

    private var travel: CGFloat {
        contentHeight / 2
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Palette.fieldFill)
                .stroke(isFocused ? Palette.fieldFocusRing : .clear, lineWidth: 1)
                .shadow(color: .black.opacity(0.3), radius: 10, y: 4)

            VStack(alignment: .leading, spacing: 0) {
                labelRow
                input
                    .offset(y: isRaised ? 4 : -5)
            }
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height
            } action: { height in
                contentHeight = height
            }
            .padding(.horizontal, 12)
            .offset(y: isRaised ? 6 : 0)
        }
        .frame(height: 64)
        .geometryGroup()
        .contentShape(.rect(cornerRadius: 8))
        .onTapGesture {
            focus.wrappedValue = field
        }
        .animation(.focus, value: isRaised)
        .animation(.focus, value: isFocused)
    }

    private var labelRow: some View {
        Text(label)
            .font(.metropolis(.thin, size: 12))
            .hidden()
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .leading) {
                ZStack(alignment: .leading) {
                    raisedLabel
                    placeholder
                }
            }
    }

    private var raisedLabel: some View {
        Text(label)
            .font(.metropolis(.thin, size: 12))
            .foregroundStyle(Palette.fieldLabel)
            .scaleEffect(isRaised || reduceMotion ? 1 : 1 / labelScale, anchor: .leading)
            .offset(y: isRaised || reduceMotion ? -8 : travel - 5)
            .opacity(isRaised ? 1 : 0)
            .accessibilityHidden(true)
    }

    private var placeholder: some View {
        Text(label)
            .font(.metropolis(.regular, size: 16))
            .foregroundStyle(Palette.placeholder)
            .scaleEffect(isRaised && !reduceMotion ? labelScale : 1, anchor: .leading)
            .offset(y: isRaised && !reduceMotion ? -8 : travel - 5)
            .opacity(isRaised ? 0 : 1)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private var input: some View {
        Group {
            if kind == .password {
                SecureField("", text: $text)
            } else {
                TextField("", text: $text)
            }
        }
        .font(.metropolis(.regular, size: 16))
        .foregroundStyle(Palette.text)
        .focused(focus, equals: field)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .textContentType(kind.contentType)
        .keyboardType(kind.keyboardType)
        .accessibilityLabel(label)
    }
}
