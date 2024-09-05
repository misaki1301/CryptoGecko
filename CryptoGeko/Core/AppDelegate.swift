//
//  AppDelegate.swift
//  CryptoGeko
//
//  Created by Paul Frank on 13/12/23.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		UNUserNotificationCenter.current().delegate = self
		
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
		
		return true
	}
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
		
		dump(userInfo)
		let isTransfer = userInfo["is-transfer"] as? Bool ?? false
		let content = UNMutableNotificationContent()
		content.title = "Feed the cat"
		content.subtitle = "It looks hungry"
		content.sound = isTransfer ? UNNotificationSound(named: UNNotificationSoundName("pacman.wav")) : UNNotificationSound.default
		
			// show this notification five seconds from now
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		
			// choose a random identifier
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		
			// add our notification request
		try? await UNUserNotificationCenter.current().add(request)
		return UIBackgroundFetchResult.newData
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenString = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
		print("Device push notification token - \(tokenString)")
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register for remote notification. Error \(error)")
	}
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		print("WILL PRESENT")
		dump(notification.request.content.userInfo)
		print("present in foreground")
		completionHandler([.banner,.list,.sound,.badge])
	}
	
}
