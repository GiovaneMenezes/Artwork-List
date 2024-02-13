import Foundation

struct PeriodFormatter {
    static func period(start: Int?, end: Int?) -> String {
        [
            start?.description,
            end?.description ?? (start != nil ? "Now" : nil)
        ].compactMap { $0 }
            .joined(separator: " - ")
    }
}
