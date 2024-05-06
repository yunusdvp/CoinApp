//
//  ViewController.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import UIKit

enum SortCriteria: Int {
case priceAscending = 0
case priceDescending = 1
case marketCapAscending = 2
case marketCapDescending = 3
case volume24hAscending = 4
case volume24hDescending = 5
case changeAscending = 6
case changeDescending = 7
case listedAtAscending = 8
case listedAtDescending = 9
}

class ViewController: UIViewController {
    var coinArray = [Coin]()
    var sortState = [String: Bool]()
    @IBOutlet weak var coinCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCoins()
        coinCollectionView.dataSource = self
        coinCollectionView.delegate = self
        coinCollectionView.register(UINib(nibName: CoinCell.identifier, bundle: nil), forCellWithReuseIdentifier: CoinCell.identifier)
        coinCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
    }
    func setupBarButton() {
        let sortButton = UIBarButtonItem(title: "Sırala", style: .plain, target: self, action: #selector(showSortOptions))
        navigationItem.rightBarButtonItem = sortButton
    }
    @objc func showSortOptions() {
        let actionSheet = UIAlertController(title: "Sırala", message: "Coin'leri nasıl sıralamak istersiniz?", preferredStyle: .actionSheet)

        // Sıralama seçenekleri ve handler'lar
        let sortOptions = [
            ("Fiyata Göre Artan", SortCriteria.priceAscending, "Price ↑"),
            ("Fiyata Göre Azalan", SortCriteria.priceDescending, "Price ↓"),
            ("Market Cap'e Göre Artan", SortCriteria.marketCapAscending, "Market Cap ↑"),
            ("Market Cap'e Göre Azalan", SortCriteria.marketCapDescending, "Market Cap ↓"),
            ("24h Volume'e Göre Artan", SortCriteria.volume24hAscending, "Volume 24h ↑"),
            ("24h Volume'e Göre Azalan", SortCriteria.volume24hDescending, "Volume 24h ↓"),
            ("Değişim Oranına Göre Artan", SortCriteria.changeAscending, "Change ↑"),
            ("Değişim Oranına Göre Azalan", SortCriteria.changeDescending, "Change ↓"),
            ("Listeleme Tarihine Göre En Eski", SortCriteria.listedAtAscending, "Listed At ↑"),
            ("Listeleme Tarihine Göre En Yeni", SortCriteria.listedAtDescending, "Listed At ↓")
        ]

        for (title, criteria, navTitle) in sortOptions {
            actionSheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                self?.sortCoins(by: criteria)
                self?.navigationItem.title = navTitle
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }

        present(actionSheet, animated: true, completion: nil)
    }


    
    

    func sortCoins(by criteria: SortCriteria) {
        switch criteria {
        case .priceAscending:
            coinArray.sort(by: { Double($0.price ?? "") ?? 0 < Double($1.price ?? "") ?? 0 })
        case .priceDescending:
            coinArray.sort(by: { Double($0.price ?? "") ?? 0 > Double($1.price ?? "") ?? 0 })
        case .marketCapAscending:
            coinArray.sort(by: { Double($0.marketCap ?? "") ?? 0 < Double($1.marketCap ?? "") ?? 0 })
        case .marketCapDescending:
            coinArray.sort(by: { Double($0.marketCap ?? "") ?? 0 > Double($1.marketCap ?? "") ?? 0 })
        case .volume24hAscending:
            coinArray.sort(by: { Double($0.the24HVolume ?? "") ?? 0 < Double($1.the24HVolume ?? "") ?? 0 })
        case .volume24hDescending:
            coinArray.sort(by: { Double($0.the24HVolume ?? "") ?? 0 > Double($1.the24HVolume ?? "") ?? 0 })
        case .changeAscending:
            coinArray.sort(by: { Double($0.change ?? "") ?? 0 < Double($1.change ?? "") ?? 0 })
        case .changeDescending:
            coinArray.sort(by: { Double($0.change ?? "") ?? 0 > Double($1.change ?? "") ?? 0 })
        case .listedAtAscending:
            coinArray.sort(by: { ($0.listedAt ?? 0) < ($1.listedAt ?? 0) })
        case .listedAtDescending:
            coinArray.sort(by: { ($0.listedAt ?? 0) > ($1.listedAt ?? 0) })
        }
        coinCollectionView.reloadData()
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
    
    @IBAction func sortedBarButton(_ sender: UIBarButtonItem) {
        showSortOptions()
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
            fatalError("Unexpected kind or unable to dequeue HeaderView")
        }

        header.delegate = self
        return header
    }


    
    
}
extension ViewController: HeaderDelegate {
    func didSelectHeaderSort(_ criteria: SortCriteria) {
        sortCoins(by: criteria)
        coinCollectionView.reloadData()
    }
}


