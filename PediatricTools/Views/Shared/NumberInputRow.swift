import SwiftUI

struct NumberInputRow: View {
    let labelKey: String
    let unitKey: String
    @Binding var value: String
    var placeholder: String = "0"

    var body: some View {
        HStack {
            Text(String(localized: String.LocalizationValue(labelKey)))
            Spacer()
            HStack(spacing: 4) {
                TextField(placeholder, text: $value)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
                Text(String(localized: String.LocalizationValue(unitKey)))
                    .foregroundStyle(.secondary)
                    .frame(width: 40, alignment: .leading)
            }
        }
    }
}
