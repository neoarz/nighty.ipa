import SwiftUI

struct CreditLink: View {
    var body: some View {
        Link(destination: URL(string: "https://github.com/neoarz")!) {
            HStack(spacing: 4) {
                Text("made with ❤️ by")
                    .foregroundStyle(Palette.text.opacity(0.7))
                Text("neoarz")
                    .foregroundStyle(Palette.text)
                    .underline()
            }
            .font(.metropolis(.regular, size: 12))
        }
    }
}
