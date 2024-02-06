//
//  Coin.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 19/11/23.
//

import Foundation

struct Coin: Codable, Identifiable {
	var id: String
	var name: String
	var apiSymbol: String
	var symbol: String
	var marketCapRank: UInt?
	var thumb: String
	var large: String
}
