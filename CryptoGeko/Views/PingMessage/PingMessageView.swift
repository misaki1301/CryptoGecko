//
//  PingMessageView.swift
//  CryptoGeko
//
//  Created by Paul Frank Pacheco Carpio on 19/11/23.
//

import MountainViewUI
import SwiftUI

struct PingMessageView: View {
    @ObservedObject private var viewModel = PingViewModel()

    var body: some View {
        VStack {
            Text("El mensaje")
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text("\(viewModel.pingMessage)")
            }
            MountainViewButton(text: "Enviar Ping Async", action: { callPing() }, buttonStyle: MountainButtonStyle())
            MountainViewButton(text: "Enviar Ping Closure", action: { callPingClosure() }, buttonStyle: MountainButtonStyle())
            MountainViewButton(text: "Enviar Ping Combine", action: { callPingCombine() }, buttonStyle: MountainButtonStyle())
        }
    }

    private func callPing() {
        Task {
            try await viewModel.getPingAsync()
        }
    }

    private func callPingClosure() {
        viewModel.getPingByClosures()
    }
	
	private func callPingCombine() {
		viewModel.getPingByCombine()
	}
}

#Preview {
    PingMessageView()
}
