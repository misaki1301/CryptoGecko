//
//  PingViewModel.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 19/11/23.
//

import Foundation
import Combine

@MainActor
class PingViewModel: ObservableObject {
    
    @Published var pingMessage: String = ""
    @Published var isLoading: Bool = false
	
	private var cancellables: Set<AnyCancellable> = []
    
    func getPingAsync() async throws {
        do {
            isLoading.toggle()
            self.pingMessage = try await CoinGeckoService.shared.getServerStatusPing().geckoSays
            print(self.pingMessage)
            isLoading.toggle()
        } catch {
            throw error
        }
    }
    
    func getPingByClosures() {
            CoinGeckoService.shared.getServerStatusPing { result in
                DispatchQueue.main.async {
                    self.isLoading = true
                }
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.pingMessage = response.geckoSays
                        self.isLoading = false
                    }
                case .failure(let error):
                    print("Error \(error)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    
                }
            }
    }
	
	func getPingByCombine() {
		CoinGeckoService.shared.getServerStatusPing()
			.receive(on: DispatchQueue.main, options: nil)
			.sink { [weak self] result in
				self?.pingMessage = result
				print("\(result)")
			}
			.store(in: &cancellables)
	}
}
