//
//  UILabel + Ext.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 6.05.2024.
//

import UIKit

extension UILabel {
    func setChangeTextAndColor(with change: String?, applyBackgroundChange: Bool = false, fallbackText: String = "N/A") {
        guard let change = change, let changeFirstChar = change.first else {
            self.text = fallbackText
            self.backgroundColor = .clear
            self.textColor = .black
            return
        }

        if applyBackgroundChange {
            self.backgroundColor = changeFirstChar == "-" ? UIColor.red.withAlphaComponent(0.8) : UIColor.green2.withAlphaComponent(0.7)
            self.layer.cornerRadius = 5
            self.clipsToBounds = true
            self.textColor = .white
            } else {
                self.backgroundColor = .clear
                self.layer.cornerRadius = 0
                self.textColor = changeFirstChar == "-" ? .red : .green2
            }

            let displayText = changeFirstChar == "-" ? change : "+\(change)"
            self.text = displayText
        }

    }
