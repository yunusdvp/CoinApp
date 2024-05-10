//
//  Coinstatistics CoinStatics.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 9.05.2024.
//

import UIKit

class CoinStatistics: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
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
    func configure(name: String, value: String) {
            signLabel.text = name
            valueLabel.text = value
        }
    }



