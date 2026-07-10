//
//  SearchCoinView.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 19/11/23.
//

import SwiftUI
import Combine
import MountainViewUI

struct SearchCoinView: View {
	
	@ObservedObject private var viewModel = SearchCoinViewModel()
	
	var body: some View {
		VStack {
			VStack {
				Text("Buscador")
				TextField("Ingrese un nombre de una moneda", text: $viewModel.searchText)
			}
			.padding(.horizontal, 32)
			.textFieldStyle(.roundedBorder)
			if viewModel.isLoading {
				VStack {
					ProgressView()
					Text("Searching across the globe...")
				}.frame(maxHeight: .infinity)
			} else {
				List(viewModel.coinList) { coin in
					MountainCardView(padding: 12) {
						HStack {
							AsyncImage(url: URL(string: coin.thumb)) { image in
								image.resizable()
									.frame(width: 24, height: 24)
							} placeholder: {
								ProgressView()
							}
							
							Text("\(coin.name)")
							Spacer()
							if let marketCapRank = coin.marketCapRank {
								Text("#\(marketCapRank)")
							} else {
								Text("Uknown Rank")
							}
						}
					}.listRowSeparator(.hidden)
				}.listStyle(.plain)
					
			}
			
		}
	}
}

#Preview {
    SearchCoinView()
}
