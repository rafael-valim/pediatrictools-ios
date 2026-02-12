import SwiftUI

struct NumberInputRow: View {
    let labelKey: String
    let unitKey: String
    @Binding var value: String
    var placeholder: String = "0"
    var range: ClosedRange<Double>? = nil

    private var isOutOfRange: Bool {
        guard let range, let number = Double(value), !value.isEmpty else { return false }
        return !range.contains(number)
    }

    var body: some View {
        HStack {
            Text(LocalizedStringKey(labelKey))
            Spacer()
            HStack(spacing: 4) {
                TextField(placeholder, text: $value)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
                    .foregroundStyle(isOutOfRange ? .red : .primary)
                Text(LocalizedStringKey(unitKey))
                    .foregroundStyle(isOutOfRange ? .red : .secondary)
                    .frame(width: 40, alignment: .leading)
            }
        }
    }
}
