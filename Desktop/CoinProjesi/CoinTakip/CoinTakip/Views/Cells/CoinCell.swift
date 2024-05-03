//
//  CoinCell.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import UIKit
import Kingfisher

class CoinCell: UICollectionViewCell {
    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinPriceLabel: UILabel!
    @IBOutlet weak var coinChangeLabel: UILabel!
    
    static let identifier = "CoinCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(withModel model: Coin){
        self.coinSymbolLabel.text = model.symbol
        self.coinNameLabel.text = model.name
        if let price = model.price{
            let truncatedPrice = String(price.prefix(9))
            self.coinPriceLabel.text = "$\(truncatedPrice)"
        }
        
        self.coinChangeLabel.text = model.change
        guard let url = URL(string: model.iconURL ?? "") else{
            return
        }
        let placeholderImage = UIImage(named: "placeholder")
        let errorImage = UIImage(named: "errorImage")
        
        guard let urlString = model.iconURL,
              let url = URL(string: urlString) else{
            self.coinImage.image = errorImage
            return
        }
        self.coinImage.setImage(from: url,placeholder: placeholderImage)
        
    }
    
}
      
