//
//  UIDevice+Extension.swift
//  WJExtension
//
//  Created by shuo on 2017/6/5.
//  Copyright © 2017年 wanjia. All rights reserved.
//

import UIKit

public extension UIDevice {
    /// 是否为模拟器
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
    
    static var isIpad: Bool {
        return UIDevice.current.model.hasPrefix("iPad")
    }
    
    static var isRETIAN_3_5: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 320, height: 480).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static var isRETIAN_4_0: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 320, height: 568).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static var isIPHONE_4_7: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 375, height: 667).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static var isIPHONE_5_5: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 414, height: 736).equalTo(UIScreen.main.bounds.size) : false
    }
    
    static var isIPHONE_X: Bool {
        return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 375, height: 812).equalTo(UIScreen.main.bounds.size) : false
    }
    
}
