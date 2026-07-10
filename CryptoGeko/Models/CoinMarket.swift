//
//  CoinMarket.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 20/11/23.
//

import Foundation

struct CoinMarket: Codable, Identifiable {
	let id, symbol, name: String
	let image: String
	let currentPrice: Double
	let marketCap, marketCapRank, fullyDilutedValuation, totalVolume: Int
	let high24H, low24H, priceChange24H, priceChangePercentage24H: Double
	let marketCapChange24H: Int
	let marketCapChangePercentage24H, circulatingSupply, totalSupply: Double
	let maxSupply: Int?
	let ath, athChangePercentage: Double
	let athDate: String
	let atl, atlChangePercentage: Double
	let atlDate: String
	let roi: Roi?
	let lastUpdated: String
	let priceChangePercentage1HInCurrency: Double
}

struct Roi: Codable {
	let times: Double
	let currency: String
	let percentage: Double
}

