//
//  AppDelegate.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
// 

import UIKit
import Fabric
import Crashlytics
//import IFlyMSC

//@UIApplicationMain
// Swift没有了main.m文件，@UIApplicationMain是程序的入口

class Person: NSObject {
    var name: String = ""
    var age: Int = 0
}


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.global().async {
            AMapServices.shared().apiKey = "PAGaodeMapCommonStruct.kGaodeMapKey"
        }
        replyPushNotificationAuthorization(application)
        
        Style.setupStyle()
        #if !(arch(i386) || arch(x86_64))
            // 真机
        #else
            // 模拟器
        #endif
        /// 添加系统的调试视图， 尽在iOS10之后可用，两只手指点击状态栏显示
        let overlayClass = NSClassFromString("UIDebuggingInformationOverlay") as? UIWindow.Type
        _ = overlayClass?.perform(NSSelectorFromString("prepareDebuggingOverlay"))
        
        let str = "1234"
        let subStr = str.substring(from: 1)
        #if DEBUG
            print("debug subStr = \(subStr)")
            #else
            print("release subStr = \(subStr)")
            #endif
        paUtilTest()
        testReturn()
        
        return true
    }
    
    func testReturn() {
        if UIScreen.width > 100 {
            return
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func paUtilTest() {
        let arr = ["abc", "defg", "hahah"]
        let arrStr = PAUtil.dismantleStringArray(arr, by: "-")
        print("arrStr = \(arrStr)")
    }

    func setupSMC() {
        IFlySpeechUtility.createUtility("appid=5aeff098")
    }

}


