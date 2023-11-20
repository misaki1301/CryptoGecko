//
//  SearchCoinViewModel.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 19/11/23.
//

import Foundation
import Combine

@MainActor
class SearchCoinViewModel: ObservableObject {
	@Published var isLoading: Bool = false
	@Published var coinList: [Coin] = []
	@Published var searchText: String = ""
	
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		//self.setupDebounceSearchText()
		self.setupDebounceSearchTextCombine()
	}
	
	func searchCoinsByName(for name: String) async throws {
		do {
			isLoading = true
			self.coinList = try await CoinGeckoService.shared.getCoinsByName(for: name).coins
			print(self.coinList)
			isLoading = false
		} catch {
			throw error
		}
	}
	
	func setupDebounceSearchText() {
		$searchText.debounce(for: .seconds(3), scheduler: DispatchQueue.main)
			//.collect()
			.sink { [weak self] value in
				Task {
					print("PACMAN")
					print("values after debounce of 3 seconds \(value)")
					try await self?.searchCoinsByName(for: value)
				}
			}
			.store(in: &cancellables)
	}
	
	// - MARK: Full Combine operation
	func searchCoinsByName(for name: String) {
		CoinGeckoService.shared.getCoinsByName(for: name)
			.receive(on: DispatchQueue.main, options: nil)
			.sink { [weak self] result in
				self?.coinList = result.coins
				print("\(result)")
			}
			.store(in: &cancellables)
	}
	func setupDebounceSearchTextCombine() {
		$searchText.debounce(for: .seconds(3), scheduler: DispatchQueue.main)
			.sink { [weak self] value in
				self?.searchCoinsByName(for: value)
			}
			.store(in: &cancellables)
	}
}
