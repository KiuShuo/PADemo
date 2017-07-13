//
//  AppDelegate+APNs.swift
//  wanjia2B
//
//  Created by shuo on 2017/6/9.
//  Copyright © 2017年 pingan. All rights reserved.
//  APNs

import Foundation
import UserNotifications
import CoreLocation
import UIKit

/**
 http://www.jianshu.com/p/c58f8322a278
 http://www.jianshu.com/p/81c6bd16c7ac
 
 
 自定义推送声音：(以声音文件unbelievable.caf为例)
 1. 将可识别的声音文件unbelievable.caf添加到项目中，并在targets->Build Phases(编译阶段)->Copy Bundle Resourse(复制包资源) 选项下add unbelievable.caf文件；
 2. 注册推送时需要有sound选项；
 3. 后台推送时，sound为对应的声音文件名称...sound: "unbelievable.caf"...
 
 无论应用在后台还是已经被杀死，推送过来的消息都为unbelievable.caf文件中的声音。
 
 
 关于 "content-available": 1
 应用在后台时，收到推送消息后如果用户不点击消息，App不知道收到了消息（代理方法不会执行），除非使用静默消息
 // 应用在后台时，收到下面的三种消息的，用户不点击消息时，代理函数的执行情况：
 // 用户能正常看到消息，代理函数不会执行，即App不知道收到了消息
 {"aps":{"alert":"Testing.. (1)","badge":1,"sound":"default"}}
 // 用户看不到消息，但是App会执行application:didReceiveRemoteNotification:fetchCompletionHandler:函数
 {"aps":{"content-available":1}}
 // 用户能正常看到消息，App也会执行application:didReceiveRemoteNotification:fetchCompletionHandler:函数
 {"aps":{"alert":"Testing.. (1)","badge":1,"sound":"default", "content-available":1}}
 
 */


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func replyPushNotificationAuthorization(_ application: UIApplication) {
        creatLocalNotification()
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                print("granted = \(granted), error = \(String(describing: error))")
            })
            // 可以及时获取用的对推送通知的设置（可以用来判断用户是否允许推送）
            center.getNotificationSettings(completionHandler: { (setting) in
                print("setting = \(setting)")
            })
        } else {
            let pushNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            print("setting types = \(dump(pushNotificationSettings.types))")
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenStr = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenStr = \(deviceTokenStr)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("apns 注册失败:\(error)")
    }
    
    @available(iOS 10.0, *)
    /// iOS10之后： UIApplicationStateInactive/UIApplicationStateActive + 远程消息／本地消息
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        // PAAlertView.showBaseAlert(title: "测试iOS10")
        let request = response.notification.request
        let userInfo = request.content.userInfo
        
        if request.trigger is UNPushNotificationTrigger { /// 远程推送
            print("userInfo = \(userInfo)")
        } else {
            print("userInfo = \(userInfo)")
        }
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    /// iOS10之后：UIApplicationStateActive + 远程消息／本地消息
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let request = notification.request
        let userInfo = request.content.userInfo
        if request.trigger is UNPushNotificationTrigger { // 远程推送
            //
        }
        print("userInfo = \(userInfo)")
        completionHandler([.alert, .sound, .badge])
    }
    
    /// iOS10之前：远程消息 + UIApplicationStateActive／UIApplicationStateInactive
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // PAAlertView.showBaseAlert(title: "测试iOS10之前")
        if UIApplication.shared.applicationState == .active {
            //
        }
        completionHandler(.newData)
    }
    
    /// iOS10之前：本地消息 + UIApplicationStateActive／UIApplicationStateInactive
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if UIApplication.shared.applicationState == .inactive {
            //
        }
    }
    
}

// Local Notification
extension AppDelegate {
    
    func creatLocalNotification() {
        if #available(iOS 10.0, *) {
            // 定时通知
            // 如果repeat = true, timeInterval > 60.0s
            let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            var trigger: UNNotificationTrigger = timeTrigger
            
            // 定期通知
            var dateComponents = DateComponents()
            dateComponents.weekday = 2
            dateComponents.hour = 11
            dateComponents.minute = 15
            let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            trigger = calendarTrigger
            
            
            // 定点通知 住的地方(121.540041,31.187592) 公司(121.456442,31.182948)
            let locationCenter = CLLocationCoordinate2DMake(121.540041,31.187592)
            let region = CLCircularRegion(center: locationCenter, radius: 500, identifier: "平安大厦B座")
            region.notifyOnEntry = true // 
            region.notifyOnExit = true
            let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: true)
            trigger = locationTrigger
            
            // 设置content
            let content = UNMutableNotificationContent()
            content.title = "这是一条本地消息（这是消息的title）"
            content.subtitle = "创建于2017年07月10日的一条本地推送消息（这是消息的subtitle）"
            content.body = "发送这条消息是用来测试本地推送服务（这是消息内容的body）"
            content.badge = NSNumber(integerLiteral: 100)
            content.sound = UNNotificationSound(named: "unbelievable.caf")
            content.userInfo = ["key1": "value1", "key2": "value2"]
            let identifier = "kiushuo.timeInterval.localNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: { (error) in
                print("添加本地推送error = \(String(describing: error))")
            })
        }
    }
    
    func creatNotificationAction() {
        if #available(iOS 10.0, *) {
            //
        } else {
            // Fallback on earlier versions
        }
    }
    
}

