//
//  NotificationViewController.swift
//  PANotificationContent
//
//  Created by shuo on 2017/7/10.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var label: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        let arr = notification.request.content.attachments
        print("arr = \(arr)")
        if let attachment = notification.request.content.attachments.first {
            if attachment.url.startAccessingSecurityScopedResource() {
                let image = UIImage(contentsOfFile: attachment.url.path)
//                l``et image: UIImage? = PAFileManager.fileManager.getDataFromSandbox("Image.jpg", directory: "Documents", key: "123")
                self.imageView.image = image
            }
        }
    }
    
}

