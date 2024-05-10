//
//  UIViewController+Ext.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 10.05.2024.
//

import UIKit
extension UIViewController {
    func addDismissKeyboardTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissInputViews))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }
        @objc private func dismissInputViews() {
            view.endEditing(true)
        }
    
}
