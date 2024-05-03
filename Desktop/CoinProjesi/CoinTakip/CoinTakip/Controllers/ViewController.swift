//
//  ViewController.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    var coinArray = [Coin]()
    
    @IBOutlet weak var coinCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCoins()
        coinCollectionView.dataSource = self
        coinCollectionView.delegate = self
        coinCollectionView.register(UINib(nibName: CoinCell.identifier, bundle: nil), forCellWithReuseIdentifier: CoinCell.identifier)
        
    }
    func fetchCoins() {
        CoinLogic.shared.getCoins { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let welcome):
                    if let coins = welcome.data?.coins {
                        self?.coinArray = coins
                        print("Toplam coin sayısı: \(coins.count)")
                        self?.coinCollectionView.reloadData()
                    } else {
                        print("Coin listesi alınamadı")
                    }
                case .failure(let error):
                    print("Hata oluştu: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        coinArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = coinCollectionView.dequeueReusableCell(withReuseIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell
        else{
            return UICollectionViewCell()
        }
        cell.configure(withModel: coinArray[indexPath.row])
        return cell
    }
    
    
}

