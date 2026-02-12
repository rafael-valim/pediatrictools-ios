import SwiftUI

/// A reusable row for scoring criteria with minScore–maxScore score buttons.
/// Used by Apgar, PEWS, FLACC, GCS, and PRAM calculators.
struct ScoreSelectorRow: View {
    let nameKey: String
    let maxScore: Int
    let descriptions: [Int: String]
    @Binding var selectedScore: Int
    var minScore: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(nameKey))
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 8) {
                ForEach(minScore...maxScore, id: \.self) { score in
                    Button {
                        selectedScore = score
                    } label: {
                        VStack(spacing: 2) {
                            Text("\(score)")
                                .font(.caption.weight(.bold))

                            if let descKey = descriptions[score] {
                                Text(LocalizedStringKey(descKey))
                                    .font(.system(size: 9))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedScore == score ? Color.accentColor : Color(.systemGray5))
                        )
                        .foregroundStyle(selectedScore == score ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
