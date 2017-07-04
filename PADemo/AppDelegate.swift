//
//  AppDelegate.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

extension UIDevice {
    /// 是否为模拟器 #if (arch(i386) || arch(x86_64)) && os(iOS)
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Style.setupStyle()
        #if !(arch(i386) || arch(x86_64))
            // 真机
            test()
        #else
            // 模拟器
        #endif
        
        /// 添加系统的调试视图， 尽在iOS10之后可用，两只趾头点击状态栏显示
        let overlayClass = NSClassFromString("UIDebuggingInformationOverlay") as? UIWindow.Type
        _ = overlayClass?.perform(NSSelectorFromString("prepareDebuggingOverlay"))
        
        
        paUtilTest()

        return true
    }

    func paUtilTest() {
        let arr = ["abc", "defg", "hahah"]
        let arrStr = PAUtil.dismantleStringArray(arr, by: "-")
        print("arrStr = \(arrStr)")
    }


}

