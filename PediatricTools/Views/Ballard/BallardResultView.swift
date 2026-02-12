import SwiftUI

struct BallardResultView: View {
    let neuromuscularScore: Int
    let physicalScore: Int

    private var totalScore: Int { neuromuscularScore + physicalScore }
    private var gestationalAge: Double { BallardCalculator.gestationalAge(fromScore: totalScore) }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ScoreColumn(
                    titleKey: "result_neuromuscular",
                    score: neuromuscularScore
                )
                Divider()
                ScoreColumn(
                    titleKey: "result_physical",
                    score: physicalScore
                )
                Divider()
                ScoreColumn(
                    titleKey: "result_total",
                    score: totalScore
                )
            }
            .fixedSize(horizontal: false, vertical: true)

            Divider()

            HStack(spacing: 4) {
                Text("result_gestational_age")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(formattedGestationalAge)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.accent)
            }
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, y: -2)
        .padding(.horizontal)
    }

    private var formattedGestationalAge: String {
        let weeks = Int(gestationalAge)
        let remainder = gestationalAge - Double(weeks)
        if remainder < 0.01 {
            return String(localized: "\(weeks) result_weeks")
        }
        let days = Int(round(remainder * 7))
        return String(localized: "\(weeks) result_weeks_and \(days) result_days")
    }
}

private struct ScoreColumn: View {
    let titleKey: String
    let score: Int

    var body: some View {
        VStack(spacing: 2) {
            Text(String(localized: String.LocalizationValue(titleKey)))
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(score)")
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
    }
}
