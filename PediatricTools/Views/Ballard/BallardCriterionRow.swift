import SwiftUI

struct BallardCriterionRow: View {
    let criterion: BallardCriterion
    @Binding var selectedScore: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: String.LocalizationValue(criterion.localizedKey)))
                .font(.subheadline.weight(.semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Array(criterion.scoreRange), id: \.self) { score in
                        Button {
                            selectedScore = score
                        } label: {
                            VStack(spacing: 2) {
                                Text("\(score)")
                                    .font(.caption.weight(.bold))
                                    .frame(minWidth: 28)

                                if let descKey = criterion.descriptionKeys[score] {
                                    Text(String(localized: String.LocalizationValue(descKey)))
                                        .font(.system(size: 9))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                        .frame(width: 64)
                                }
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 4)
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
        }
        .padding(.vertical, 4)
    }
}
