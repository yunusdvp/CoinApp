//
//  Int+ Ext.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 9.05.2024.
//

import Foundation

extension Int {
    func toFormattedDate(format: String = "dd/MM/yyyy") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") 
        return dateFormatter.string(from: date)
    }
}
extension Optional where Wrapped: Numeric {
    func orZero() -> Wrapped {
        return self ?? 0
    }
}
