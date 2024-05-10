//
//  CoinDetailView.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 6.05.2024.
//

import UIKit
import WebKit
class CoinDetailView: UIView {
    
    @IBOutlet weak var rankView: CoinStatistics!
    @IBOutlet weak var volumeView: CoinStatistics!
    @IBOutlet weak var minValueView: CoinStatistics!
    @IBOutlet weak var maxValueView: CoinStatistics!
    @IBOutlet weak var marketCapView: CoinStatistics!
    
    private var view: UIView!
    var model: Coin?
    var onMoreDetailsRequested: ((URL) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        return view
    }
    
    private func configureView() {
        guard let viewFromNib = loadViewFromNib() else { return }
        viewFromNib.frame = self.bounds
        viewFromNib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(viewFromNib)
    }
    public func setModel(_ model: Coin) {
                self.model = model
                configure(withModel: model)
            }
    public func configure(withModel model: Coin) {
        rankView.configure(name: "Rank", value: "#\(model.rank.orZero())")
        volumeView.configure(name: "24h Volume", value: model.the24HVolume?.formattedWithAbbreviations().asDollarCurrency ?? "N/A")
        marketCapView.configure(name: "Market Cap", value: model.marketCap?.formattedWithAbbreviations().asDollarCurrency ?? "N/A")

            if let minValue = model.sparkline?.compactMap(Double.init).min(),
               let maxValue = model.sparkline?.compactMap(Double.init).max() {
                minValueView.configure(name: "Min", value: String(String(format: "$%.8f", minValue).prefix(10)))
                maxValueView.configure(name: "Max", value: String(String(format: "$%.8f", maxValue).prefix(10)))
            }
    }
    
    @IBAction func moreDetailButtonTapped(_ sender: UIButton) {
        guard let urlString = model?.coinrankingURL, let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            onMoreDetailsRequested?(url)
    }
    private func truncateTo9Characters(value: Double) -> String {
        let formattedValue = String(format: "%.6f", value)
        
        return String(formattedValue.prefix(9)).asDollarCurrency
    }
    

}

