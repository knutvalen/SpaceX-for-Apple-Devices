import Foundation

extension Date {
    func toLaunch(precision: DatePrecision) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")

        if precision == .hour {
            formatter.setLocalizedDateFormatFromTemplate("MMMdyh")
        }

        if precision == .minute {
            formatter.setLocalizedDateFormatFromTemplate("MMMdyhm")
        }

        if precision == .second {
            formatter.setLocalizedDateFormatFromTemplate("MMMdyhms")
        }

        return formatter.string(from: self)
    }
}
