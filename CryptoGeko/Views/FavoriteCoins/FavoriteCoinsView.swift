//
//  FavoriteCoinsView.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 20/11/23.
//

import SwiftUI
import MountainViewUI

struct FavoriteCoinsView: View {
	
	@StateObject private var viewModel = FavoriteCoinsViewModel()
	
    var body: some View {
		List(viewModel.favoriteCoinList) { coin in
			MountainCardView(padding: 12) {
				HStack {
					AsyncImage(url: URL(string: coin.image)) { image in
						image.resizable()
							.frame(width: 24, height: 24)
					} placeholder: {
						ProgressView()
					}

					VStack {
						Text("\(coin.name)")
							.font(.MountainView.fixed(.bold, size: 14))
						Text("\(coin.symbol.uppercased())")
							.font(.MountainView.fixed(.regular, size: 12))
						
					}
					Spacer()
					VStack {
						Text("\(String(format: "%.2f", coin.priceChangePercentage24H))%")
						Text("$\(String(format:"%.2f", coin.currentPrice))")
					}
				}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
		.onAppear {
			viewModel.getFavoritesCoins()
		}
    }
}

#Preview {
    FavoriteCoinsView()
}
