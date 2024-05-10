//
//  UIView + Ext.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//
import UIKit
import Kingfisher
import SVGKit

extension UIImageView {
    static let svgCache = NSCache<NSString, UIImage>()

    func setImage(from url: URL, placeholder: UIImage? = nil, errorImage: UIImage? = UIImage(named: "errorImage")) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        activityIndicator.color = .gray
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if url.absoluteString.hasSuffix(".svg") {
            if let cachedImage = UIImageView.svgCache.object(forKey: url.absoluteString as NSString) {
                self.image = cachedImage
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            } else {
                DispatchQueue.global(qos: .default).async {
                    if let svgImage = SVGKImage(contentsOf: url) {
                        let uiImage = svgImage.uiImage
                        UIImageView.svgCache.setObject(uiImage!, forKey: url.absoluteString as NSString)
                        DispatchQueue.main.async {
                            self.image = uiImage
                            self.layer.add(self.fadeTransition(), forKey: nil)
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.image = errorImage
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        }
                    }
                }
            }
        } else {
            self.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.6)), .processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))), .cacheOriginalImage]) { result in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    switch result {
                    case .success(let value):
                        self.image = value.image
                        self.layer.add(self.fadeTransition(), forKey: nil)
                    case .failure(_):
                        self.image = errorImage
                    }
                }
            }
        }
    }

    private func fadeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        return transition
    }
}

