//
//  DetailViewController.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 3.05.2024.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {
    @IBOutlet weak var detailView: CoinDetailView!
    
    @IBOutlet weak var detailHeaderView: DetailHeaderView!
    @IBOutlet weak var graphScrollView: UIScrollView!
    @IBOutlet weak var lineGraphView: LineGraphView!
    @IBOutlet weak var scrollView: UIScrollView!
    var coin : Coin?
    override func viewDidLoad() {
        super.viewDidLoad()
        detailHeaderView.configure(withModel: coin!)
        detailView.setModel(coin!)
        print(coin ?? "")
        detailView.onMoreDetailsRequested = { [weak self] url in
                self?.openWebView(with: url)
            }
        title = coin?.symbol
        let doubleGraph : [Double] = coin?.sparkline?.compactMap{Double($0)} ?? [0,0]
        lineGraphView.setGraphData(values: doubleGraph)
        let isFavorite = CoreDataManager.shared.isFavorite(coinName: coin?.name ?? "")
            let buttonImageName = isFavorite ? "heart.fill" : "heart"
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: buttonImageName)
        
    }
    
    private func openWebView(with url: URL) {
        let webView = WKWebView(frame: UIScreen.main.bounds)
        webView.navigationDelegate = self
        let request = URLRequest(url: url)
        webView.load(request)

        let webViewController = UIViewController()
        webViewController.view = webView
        webViewController.modalPresentationStyle = .pageSheet

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = webView.center
        activityIndicator.startAnimating()
        webView.addSubview(activityIndicator)


        let closeButton = UIButton(frame: CGRect(x: 20, y: 40, width: 60, height: 30))
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .red.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 6
        closeButton.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        webView.addSubview(closeButton)

        present(webViewController, animated: true, completion: nil)
    }

    @objc func closeWebView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIBarButtonItem) {
        guard let coinName = coin?.name else { return }
            
        if CoreDataManager.shared.isFavorite(coinName: coinName) {
                CoreDataManager.shared.removeFromFavorites(coinName: coinName)
                sender.image = UIImage(systemName: "heart")
                NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
                showAlert(message: "Removed from favorites.")
            } else {
                CoreDataManager.shared.addToFavorites(coinName: coinName)
                sender.image = UIImage(systemName: "heart.fill")
                NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
                showAlert(message: "Added to favorites.")
            }
        }

        func showAlert(message: String) {
            let alert = UIAlertController(title: "Favorite", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}
extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach {
            $0.startAnimating()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach {
            $0.stopAnimating()
            $0.removeFromSuperview()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach {
            $0.stopAnimating()
            $0.removeFromSuperview()
        }
    }
}
