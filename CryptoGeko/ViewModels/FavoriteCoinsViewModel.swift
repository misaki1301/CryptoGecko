//
//  FavoriteCoinsView.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 20/11/23.
//

import Foundation
import Combine

@MainActor
class FavoriteCoinsViewModel: ObservableObject {
	@Published var favoriteCoinList: [CoinMarket] = [] {
		didSet {
			print("data updated")
			print(favoriteCoinList)
		}
	}
	@Published var isLoading = false
	
	private var cancellables: Set<AnyCancellable> = []
	
	func getFavoritesCoins() {
		Timer.publish(every: 10, on: .main, in: .default)
			.autoconnect()
			.flatMap { _ in
				CoinGeckoService.shared
					.getCoinMarkets()
			}
			.sink { [weak self] result in
				Task {
					self?.favoriteCoinList = result
					print(result)
				}
			}
			.store(in: &cancellables)
	}
	
}
