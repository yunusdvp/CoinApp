//
//  DataClass.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import Foundation

struct DataClass: Codable {
    let stats: Stats?
    let coins: [Coin]
}
