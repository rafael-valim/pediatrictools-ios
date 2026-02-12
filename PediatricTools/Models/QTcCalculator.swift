import Foundation

enum QTcCalculator {
    struct Result {
        let qtc: Double
        let interpretationKey: String
    }

    /// Bazett's formula: QTc = QT / √(RR interval)
    /// where RR = 60 / HR (in seconds)
    /// QT in milliseconds, HR in bpm
    static func calculate(qtInterval: Double, heartRate: Double, sex: Sex) -> Result? {
        guard qtInterval > 0, heartRate > 0 else { return nil }
        let rrSeconds = 60.0 / heartRate
        let qtc = qtInterval / sqrt(rrSeconds)

        let prolongedThreshold: Double = sex == .male ? 460.0 : 470.0
        let borderlineThreshold = 440.0

        let interpretation: String
        if qtc < borderlineThreshold {
            interpretation = "qtc_normal"
        } else if qtc < prolongedThreshold {
            interpretation = "qtc_borderline"
        } else {
            interpretation = "qtc_prolonged"
        }

        return Result(qtc: qtc, interpretationKey: interpretation)
    }
}
