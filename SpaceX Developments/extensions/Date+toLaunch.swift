//
//  Date+toLaunch.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 10/10/2024.
//

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
