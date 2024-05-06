//
//  CoinView.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 5.05.2024.
//

import UIKit

class CoinView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
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

}
