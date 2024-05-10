//
//  ViewController.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import UIKit

class ViewController: UIViewController {
    var coinArray = [Coin]()
    var filteredCoins = [Coin]()
    var sortState = [String: Bool]()
    var emptyMessageLabel: UILabel!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var coinCollectionView: UICollectionView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissKeyboardTapGesture()
        fetchCoins()
        setupSegmentedControl()
        setupEmptyMessageLabel()
        setupCollectionView()
        setupPickerView()
        reloadCoins()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCoins), name: .favoritesUpdated, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setupSegmentedControl() {
            segmentedControll.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
            reloadCoins()
        }
    func setupEmptyMessageLabel() {
            emptyMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyMessageLabel.text = "No coins available"
            emptyMessageLabel.textColor = .gray
        emptyMessageLabel.font = UIFont.systemFont(ofSize: 25)
            emptyMessageLabel.textAlignment = .center
            emptyMessageLabel.isHidden = true
        
            self.view.addSubview(emptyMessageLabel)
        }
    func setupCollectionView() {
            coinCollectionView.dataSource = self
            coinCollectionView.delegate = self
            coinCollectionView.register(UINib(nibName: CoinCell.identifier, bundle: nil), forCellWithReuseIdentifier: CoinCell.identifier)
        coinCollectionView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50)
            coinCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        }
    
    @objc func reloadCoins() {
            if segmentedControll.selectedSegmentIndex == 0 {
                filteredCoins = coinArray
            } else {
                let favoriteCoinNames = CoreDataManager.shared.fetchFavoriteCoinNames()
                filteredCoins = coinArray.filter { coin in
                    favoriteCoinNames.contains(coin.name ?? "")
                }
            }
            coinCollectionView.reloadData()
            updateEmptyMessageVisibility()
            
        }

    func updateEmptyMessageVisibility() {
            emptyMessageLabel.isHidden = !filteredCoins.isEmpty
        }

    func sortCoins(by criteria: SortCriteria) {
        switch criteria {
        case .priceAscending:
            filteredCoins.sort(by: { $0.price.orEmpty().orZero() < $1.price.orEmpty().orZero() })
            coinArray.sort(by: { $0.price.orEmpty().orZero() < $1.price.orEmpty().orZero() })
        case .priceDescending:
            filteredCoins.sort(by: { $0.price.orEmpty().orZero() > $1.price.orEmpty().orZero() })
            coinArray.sort(by: { $0.price.orEmpty().orZero() > $1.price.orEmpty().orZero() })
        case .marketCapAscending:
            filteredCoins.sort(by: { $0.marketCap.orEmpty().orZero() < $1.marketCap.orEmpty().orZero() })
            coinArray.sort(by: { $0.marketCap.orEmpty().orZero() < $1.marketCap.orEmpty().orZero() })
        case .marketCapDescending:
            filteredCoins.sort(by: { $0.marketCap.orEmpty().orZero() > $1.marketCap.orEmpty().orZero() })
            coinArray.sort(by: { $0.marketCap.orEmpty().orZero() > $1.marketCap.orEmpty().orZero() })
        case .volume24hAscending:
            filteredCoins.sort(by: { $0.the24HVolume.orEmpty().orZero() < $1.the24HVolume.orEmpty().orZero() })
            coinArray.sort(by: { $0.the24HVolume.orEmpty().orZero() < $1.the24HVolume.orEmpty().orZero() })
        case .volume24hDescending:
            filteredCoins.sort(by: { $0.the24HVolume.orEmpty().orZero() > $1.the24HVolume.orEmpty().orZero() })
            coinArray.sort(by: { $0.the24HVolume.orEmpty().orZero() > $1.the24HVolume.orEmpty().orZero() })
        case .changeAscending:
            filteredCoins.sort(by: { $0.change.orEmpty().orZero() < $1.change.orEmpty().orZero() })
            coinArray.sort(by: { $0.change.orEmpty().orZero() < $1.change.orEmpty().orZero() })
        case .changeDescending:
            filteredCoins.sort(by: { $0.change.orEmpty().orZero() > $1.change.orEmpty().orZero() })
            coinArray.sort(by: { $0.change.orEmpty().orZero() > $1.change.orEmpty().orZero() })
        case .listedAtAscending:
            filteredCoins.sort(by: { ($0.listedAt.orZero()) < ($1.listedAt.orZero()) })
            coinArray.sort(by: { ($0.listedAt.orZero()) < ($1.listedAt.orZero()) })
        case .listedAtDescending:
            filteredCoins.sort(by: { ($0.listedAt.orZero()) > ($1.listedAt.orZero()) })
            coinArray.sort(by: { ($0.listedAt.orZero()) > ($1.listedAt.orZero()) })
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
                        self?.reloadCoins()
                        print("Toplam coin sayısı: \(coins.count)")
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
        UIView.animate(withDuration: 0.3) {
                self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height - 216, width: self.view.frame.width, height: 216)
            }
        }
    func hidePickerView() {
        UIView.animate(withDuration: 0.7) {
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 216)
        }
    }
    }


extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCoins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = coinCollectionView.dequeueReusableCell(withReuseIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell
        else{
            return UICollectionViewCell()
        }
        cell.configure(withModel: filteredCoins[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedCoin = filteredCoins[indexPath.row]
            showDetails(for: selectedCoin)
        }

    func showDetails(for coin: Coin) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.coin = coin
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("DetailViewController couldn't be instantiated.")
        }
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
extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCoins = searchText.isEmpty ? coinArray : coinArray.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
            coinCollectionView.reloadData()
            updateEmptyMessageVisibility()
        }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func setupPickerView() {
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 216)
        pickerView.backgroundColor = UIColor.white
            view.addSubview(pickerView)
        }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return sortOptions.count
        }

        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return sortOptions[row].0
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let criteria = sortOptions[row].1
            sortCoins(by: criteria)
            hidePickerView()
            navigationItem.title = sortOptions[row].0
        }
}
