//
//  ContentView.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 19/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FavoriteCoinsView()
			.tabItem { Label("Home", systemImage: "house") }
            PingMessageView()
                .tabItem { Label("Ping", systemImage: "globe") }
			SearchCoinView()
				.tabItem { Label("Coin Search", systemImage: "bitcoinsign.circle.fill") }
        }
    }
}

#Preview {
    ContentView()
}
