//
//  DataClass.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

struct DataClass: Decodable {
    let stats: Stats?
    let coins: [Coin]
}
