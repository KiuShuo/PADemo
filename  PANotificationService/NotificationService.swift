//
//  NotificationService.swift
//  PANotificationService
//
//  Created by shuo on 2017/7/10.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            if let imageUrlStr = request.content.userInfo["image"] as? String {
                if let _ = URL(string: imageUrlStr) {
                    let _ = getImage(urlString: imageUrlStr)
                    do {
                        let imagePath = "file://" + PAFileManager.fileManager.getFileFullPathUnderDirectory("Documents", fileName: "Image.jpg")
                        let attachment = try UNNotificationAttachment(identifier: "photo", url: URL(string: imagePath)!, options: nil)
                        bestAttemptContent.attachments = [attachment]
                    } catch let error {
                        print(error)
                    }
                }
            }
//            bestAttemptContent.categoryIdentifier = "myNotificationCategory"            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func getImage(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            saveImage(image: image!)
            return image
        } catch let error {
            print("get image error = \(error)")
        }
        return nil
    }
    
    private func saveImage(image: UIImage) {
        
        let result = PAFileManager.fileManager.saveDataToSandbox(image, directory: "Documents", fileName: "Image.jpg", key: "123")
        print("\(result.0, result.1)")
    }

}
