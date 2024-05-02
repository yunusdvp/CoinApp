//
//  CoinLogic.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 2.05.2024.
//

import Foundation
import Alamofire

final class CoinLogic: CoinLogicProtocol{
    
    static let shared: CoinLogic = {
        let instance = CoinLogic()
        return instance
    }()
    
    private init() {}
    
    
    func getCoins(completionHandler: @escaping (Result<Welcome, any Error>) -> Void) {
        Webservice.shared.request(request: Router.coin, decodeType: Welcome.self, completionHandler: completionHandler)
    }
    
    
}
