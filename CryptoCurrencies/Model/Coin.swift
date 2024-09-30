//
//  Coin.swift
//  CryptoCurrencies
//
//  Created by Kapil Shivhare on 9/27/24.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String?
    let name: String?
    let image: String?
    let currentPrice: Double?
    let marketCapRank: Int?
}
