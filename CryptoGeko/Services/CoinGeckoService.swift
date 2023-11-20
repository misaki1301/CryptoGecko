//
//  CoinGeckoService.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 19/11/23.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidData(Error)
    case invalidResponse
    case invalidUrl
    case message(_ error: Error?)
}

struct PingResponse: Codable {
    var geckoSays: String
}

struct CoinResponse: Codable {
	let coins: [Coin]
}

class CoinGeckoService {
    static let shared = CoinGeckoService()
    let baseUrl = "api.coingecko.com"
    let apiKey = "CG-5mnocv4jFHNMgWvookYCHSJf"
	let queryApiKey = "x_cg_demo_api_key"
    
    private init() {}
    
    enum Endpoints {
        static let ping = "/api/v3/ping"
        static let search = "/api/v3/search"
		static let markets = "/api/v3/coins/markets"
    }
	
	func getCoinMarkets() -> AnyPublisher<[CoinMarket], Never> {
		var components = URLComponents()
		components.scheme = "https"
		components.host = baseUrl
		components.path = Endpoints.markets
		//?vs_currency=usd&ids=pancakeswap-token%2Cethereum&order=market_cap_desc&per_page=10&page=1&sparkline=false&price_change_percentage=1h&locale=en&precision=2
		components.queryItems = [
			URLQueryItem(name: "vs_currency", value: "usd"),
			URLQueryItem(name: "ids", value: "pancakeswap-token,ethereum"),
			URLQueryItem(name: "order", value: "market_cap_desc"),
			URLQueryItem(name: "per_page", value: "10"),
			URLQueryItem(name: "page", value: "1"),
			URLQueryItem(name: "sparkline", value: "false"),
			URLQueryItem(name: "price_change_percentage", value: "1h"),
			URLQueryItem(name: "locale", value: "en"),
			URLQueryItem(name: "precision", value: "2"),
			URLQueryItem(name: queryApiKey, value: apiKey)
		]
		guard let url = components.url else {
			return Just([]).eraseToAnyPublisher()
		}
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { data, response in
				do {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					let listCoinMarket = try decoder.decode([CoinMarket].self, from: data)
					return listCoinMarket
				} catch {
					return []
				}
			}.replaceError(with: [])
			.eraseToAnyPublisher()
	}
	
	func getCoinsByName(for name:String) async throws -> CoinResponse {
		var components = URLComponents()
		components.scheme = "https"
		components.host = baseUrl
		components.path = Endpoints.search
		components.queryItems = [
			URLQueryItem(name: "query", value: name),
			URLQueryItem(name: queryApiKey, value: apiKey)
		]
		
		guard let url = components.url else {
			throw NetworkError.invalidUrl
		}
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw NetworkError.invalidResponse
		}
		do {
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			if let jsonString = String(data: data, encoding: .utf8) {
				print(jsonString)
			}
			return try decoder.decode(CoinResponse.self, from: data)
		} catch {
			throw NetworkError.invalidData(error)
		}
	}
	
	func getCoinsByName(for name: String) -> AnyPublisher<CoinResponse, Never> {
		var components = URLComponents()
		components.scheme = "https"
		components.host = baseUrl
		components.path = Endpoints.search
		let query = [
			URLQueryItem(name: "query", value: name),
			URLQueryItem(name: queryApiKey, value: apiKey)
		]
		components.queryItems = query
		guard let url = components.url else {
			return Just(CoinResponse(coins: [])).eraseToAnyPublisher()
		}
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { data, response in
				do {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					let listCoin = try decoder.decode(CoinResponse.self, from: data)
					return listCoin
				} catch {
					return CoinResponse(coins: [])
				}
			}.replaceError(with: CoinResponse(coins: []))
			.eraseToAnyPublisher()
	}
    
    func getServerStatusPing() async throws -> PingResponse {
		var components = URLComponents()
		components.scheme = "https"
		components.host = baseUrl
		components.path = Endpoints.ping
		let query = [
			URLQueryItem(name: queryApiKey, value: apiKey)
		]
		components.queryItems = query
        guard let url = components.url else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            return try decoder.decode(PingResponse.self, from: data)
        } catch {
            throw NetworkError.invalidData(error)
        }
    }
    
    func getServerStatusPing(completion: @escaping (Result<PingResponse, Error>) -> Void) {
		var components = URLComponents()
		components.scheme = "https"
		components.host = baseUrl
		components.path = Endpoints.ping
		let query = [
			URLQueryItem(name: queryApiKey, value: apiKey)
		]
		components.queryItems = query
		        
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                let pingResponse = try decoder.decode(PingResponse.self, from: data)
                completion(.success(pingResponse))
            } catch {
                completion(.failure(NetworkError.invalidData(error)))
            }
        }.resume()
    }
	
	func getServerStatusPing() -> AnyPublisher<String, Never> {
		var components = URLComponents()
		components.scheme = "https"
		components.host = baseUrl
		components.path = Endpoints.ping
		let query = [
			URLQueryItem(name: queryApiKey, value: apiKey)
		]
		components.queryItems = query
		guard let url = components.url else {
			return Just("").eraseToAnyPublisher()
		}
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { data, response in
				do {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					let pingMessage = try decoder.decode(PingResponse.self, from: data)
					return pingMessage.geckoSays
				} catch {
					return ""
				}
			}.replaceError(with: "")
			.eraseToAnyPublisher()
	}

}
