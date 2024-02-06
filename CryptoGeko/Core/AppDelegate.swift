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
		return true
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
