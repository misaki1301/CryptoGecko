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
	
	@State var showing = false

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
			MountainViewButton(text: "Test Push Notification", action: {
				askNotificationPermission()
			}, buttonStyle: MountainButtonStyle())
			MountainViewButton(text: "Sheet", action: {showing.toggle()}, buttonStyle: MountainButtonStyle())
				.sheet(isPresented: $showing) {
					Text("Pacman")
						.presentationDetents([.height(300)])
				}
				
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
	
	private func askNotificationPermission() {
			// request push notification authorization
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { allowed, error in
			if allowed {
					// register for remote push notification
				DispatchQueue.main.async {
					UIApplication.shared.registerForRemoteNotifications()
				}
				print("Push notification allowed by user")
			} else {
				print("Error while requesting push notification permission. Error \(error)")
			}
		}
	}
}

#Preview {
    PingMessageView()
}
