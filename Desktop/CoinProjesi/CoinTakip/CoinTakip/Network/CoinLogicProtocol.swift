//
//  CoinLogicProtocol.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import Foundation

protocol CoinLogicProtocol{
    func getCoins(completionHandler: @escaping (Result<Welcome,Error>)-> Void)
}
