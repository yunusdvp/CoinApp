//
//  String + Ext.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 5.05.2024.
//

import Foundation

extension String {
    func formattedWithAbbreviations() -> String {
        guard let value = Double(self) else {
            return "N/A"
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        switch value {
        case 1_000_000..<1_000_000_000:
            numberFormatter.maximumFractionDigits = 1
            let formattedNumber = numberFormatter.string(from: NSNumber(value: value / 1_000_000))!
            return "\(formattedNumber)M"

        case 1_000_000_000..<1_000_000_000_000:
            numberFormatter.maximumFractionDigits = 1
            let formattedNumber = numberFormatter.string(from: NSNumber(value: value / 1_000_000_000))!
            return "\(formattedNumber)B"

        case 1_000_000_000_000...:
            numberFormatter.maximumFractionDigits = 1
            let formattedNumber = numberFormatter.string(from: NSNumber(value: value / 1_000_000_000_000))!
            return "\(formattedNumber)T"

        default:
            return numberFormatter.string(from: NSNumber(value: value)) ?? "N/A"
        }
    }
    func scientificNotationToDecimal() -> String {
            guard let doubleValue = Double(self) else { return "N/A" }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 20 
            formatter.minimumFractionDigits = 0
            return formatter.string(from: NSNumber(value: doubleValue)) ?? "N/A"
        }
    func orZero() -> Double {
            return Double(self) ?? 0.0
        }
    var asDollarCurrency: String {
            return "$\(self)"
        }
    var asBtcCurrency: String{
        return "₿\(self)"
    }
    }

extension Optional where Wrapped == String {
    func orEmpty() -> String {
        return self ?? ""
    }
}
