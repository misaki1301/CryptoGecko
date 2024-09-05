	//
	//  NotificationService.swift
	//  GeckoNotification
	//
	//  Created by Paul Frank on 13/12/23.
	//

import UserNotifications

final class NotificationService: UNNotificationServiceExtension {
	
	private var contentHandler: ((UNNotificationContent) -> Void)?
	private var bestAttemptContent: UNMutableNotificationContent?
	
	override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
		self.contentHandler = contentHandler
		bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
		print("EXTENSION")
		dump(request.content.userInfo)
		guard let data = try? JSONSerialization.data(withJSONObject: request.content.userInfo, options: [.prettyPrinted]) else {return}
		print(String(data: data, encoding: .utf8))
		defer {
			contentHandler(bestAttemptContent ?? request.content)
		}
		
			/// Add the category so the "Open Board" action button is added.
		bestAttemptContent?.categoryIdentifier = "GENERAL"
		
		guard let attachment = request.attachment else { return }
		
		bestAttemptContent?.attachments = [attachment]
	}
	
	
	override func serviceExtensionTimeWillExpire() {
			// Called just before the extension will be terminated by the system.
			// Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.https://www.livejasmin.com/en/member/chat/MaraKovalenko
		if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
			contentHandler(bestAttemptContent)
		}
	}
	
}

extension UNNotificationRequest {
	var attachment: UNNotificationAttachment? {
		guard let attachmentURL = content.userInfo["image_url"] as? String else {return nil}
		guard let urlImage = URL(string: attachmentURL) else {return nil}
		guard let imageData = try? Data(contentsOf: urlImage) else {
			return nil
		}
		return try? UNNotificationAttachment(data: imageData, options: nil)
	}
}

extension UNNotificationAttachment {
	
	convenience init(data: Data, options: [NSObject: AnyObject]?) throws {
		let fileManager = FileManager.default
		let temporaryFolderName = ProcessInfo.processInfo.globallyUniqueString
		let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(temporaryFolderName, isDirectory: true)
		
		try fileManager.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true, attributes: nil)
		let imageFileIdentifier = UUID().uuidString + ".jpg"
		let fileURL = temporaryFolderURL.appendingPathComponent(imageFileIdentifier)
		try data.write(to: fileURL)
		try self.init(identifier: imageFileIdentifier, url: fileURL, options: options)
	}
}
