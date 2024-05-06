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
        // Initialization code
    }
    
    public func configure(withModel model: Coin) {
        coinView.coinNameLabel?.text = model.name ?? "Unknown"
        coinView.marketCapLabel?.text = "$\(model.marketCap?.formattedWithAbbreviations() ?? "N/A")"
           if let price = model.price {
               let truncatedPrice = String(price.prefix(9))
               priceLabel.text = "$\(truncatedPrice)"
           } else {
               priceLabel.text = "N/A"
           }
           if let change = model.change, let changeFirstChar = change.first {
               changeLabel.textColor = changeFirstChar == "-" ? .red : .green
               changeLabel.text = change
           } else {
               changeLabel.text = "N/A"
           }
           
           let placeholderImage = UIImage(named: "placeholder")
           let errorImage = UIImage(named: "errorImage") 
           if let iconURL = model.iconURL, let url = URL(string: iconURL) {
               coinView.imageView?.setImage(from: url,placeholder: placeholderImage)
           } else {
               coinView.imageView.image = errorImage
           }
       }
}
      
