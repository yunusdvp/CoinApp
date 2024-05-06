//
//  HeaderView.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 5.05.2024.
//

import UIKit

class HeaderView: UICollectionReusableView {
    @IBOutlet var marketCapLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var changeLabel: UILabel!
       
    var delegate: HeaderDelegate?
    static let identifier = "HeaderView"
    
    var sortState: [SortCriteria: Bool] = [:]

        override func awakeFromNib() {
            super.awakeFromNib()
            setupGestures()
        }

        private func setupGestures() {
            addTapGesture(to: marketCapLabel, forCriteria: .marketCapAscending)
            addTapGesture(to: priceLabel, forCriteria: .priceAscending)
            addTapGesture(to: changeLabel, forCriteria: .changeAscending)
        }

        private func addTapGesture(to label: UILabel, forCriteria initialCriteria: SortCriteria) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
            label.tag = initialCriteria.rawValue
        }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let label = sender.view as? UILabel,
                  let initialCriteria = SortCriteria(rawValue: label.tag) else { return }
            resetSortIndicators(except: label)
            let isAscending = !(sortState[initialCriteria] ?? true)
            sortState[initialCriteria] = isAscending
            let newCriteria = isAscending ? initialCriteria : SortCriteria(rawValue: label.tag + 1)!
            updateHeaderLabel(label: label, isAscending: isAscending)
            delegate?.didSelectHeaderSort(newCriteria)
        }

        private func resetSortIndicators(except currentLabel: UILabel) {
            for label in [marketCapLabel, priceLabel, changeLabel] {
                if label != currentLabel {
                    let baseText = label?.text?.components(separatedBy: ["↑", "↓"]).first?.trimmingCharacters(in: .whitespaces) ?? ""
                    label?.text = baseText
                }
            }
        }

        func updateHeaderLabel(label: UILabel, isAscending: Bool) {
            let baseText = label.text?.components(separatedBy: ["↑", "↓"]).first?.trimmingCharacters(in: .whitespaces) ?? ""
            label.text = isAscending ? "\(baseText) ↑" : "\(baseText) ↓"
        }
    }
protocol HeaderDelegate {
    func didSelectHeaderSort(_ criteria: SortCriteria)
}
