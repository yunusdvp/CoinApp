//
//  CoinCell.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import UIKit
import Kingfisher

class CoinCell: UICollectionViewCell {

    @IBOutlet weak var coinView: CoinView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    static let identifier = "CoinCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSeparatorView()
        
    }
    private let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray 
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    private func setupSeparatorView() {
            contentView.addSubview(separatorView)
            NSLayoutConstraint.activate([
                separatorView.heightAnchor.constraint(equalToConstant: 1),
                separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }

    public func configure(withModel model: Coin) {
        coinView.coinNameLabel?.text = model.name ?? "Unknown"
        coinView.marketCapLabel?.text = model.symbol ?? "N/A"
           if let price = model.price {
               let truncatedPrice = String(price.prefix(9))
               priceLabel.text = truncatedPrice.asDollarCurrency
           } else {
               priceLabel.text = "N/A"
           }
        changeLabel.setChangeTextAndColor(with: model.change, applyBackgroundChange: true)
           let placeholderImage = UIImage(named: "placeholder")
           let errorImage = UIImage(named: "errorImage") 
           if let iconURL = model.iconURL, let url = URL(string: iconURL) {
               coinView.imageView?.setImage(from: url,placeholder: placeholderImage)
           } else {
               coinView.imageView.image = errorImage
           }
       }
}
      
