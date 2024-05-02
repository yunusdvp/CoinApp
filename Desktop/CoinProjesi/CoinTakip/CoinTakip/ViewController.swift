//
//  ViewController.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import UIKit

class ViewController: UIViewController {
    var coins = [Coin]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the vi

        
        let coinLogic = CoinLogic.shared

        
        coinLogic.getCoins { result in
            switch result {
            case .success(let dataClass):
                
                if let jsonData = try? JSONEncoder().encode(dataClass),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            case .failure(let error):
                
                print("An error occurred: \(error)")
            }
        }

    }


}

