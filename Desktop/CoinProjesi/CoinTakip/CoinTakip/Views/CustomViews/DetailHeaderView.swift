//
//  DetailHeaderView.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 9.05.2024.
//

import UIKit

class DetailHeaderView: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var coinImage: UIImageView!
    
    @IBOutlet weak var coinName: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var changeLabel: UILabel!
    
    private var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
        
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    private func setupBorder() {
        layer.borderWidth = 0.4
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
        let nib = UINib(nibName: name, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        
        return view
    }
    private func configureView() {
        guard let nibView = loadViewFromNib() else { return }
        containerView = view
        bounds = nibView.frame
        addSubview(nibView)
    }
    func configure(withModel model: Coin) {
        coinName.text = model.name ?? "Unknown"
        if let price = model.price {
            let truncatedPrice = String(price.prefix(9))
            priceLabel.text = truncatedPrice.asDollarCurrency
        } else {
            priceLabel.text = "N/A"
        }
        if let minValue = model.sparkline?.compactMap(Double.init).min(),
           let maxValue = model.sparkline?.compactMap(Double.init).max(){
            let changeDetail = "\(model.change ?? "") $\(Float(maxValue-minValue))"
            changeLabel.setChangeTextAndColor(with: changeDetail)
            
        }
        
        
        let placeholderImage = UIImage(named: "placeholder")
        let errorImage = UIImage(named: "errorImage")
        if let iconURL = model.iconURL, let url = URL(string: iconURL) {
            coinImage.setImage(from: url,placeholder: placeholderImage)
        } else {
            coinImage.image = errorImage
        }
        }
    }


