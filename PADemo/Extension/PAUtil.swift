//
//  PAUtil.swift
//  wanjia2B
//
//  Created by shuo on 2017/6/20.
//  Copyright © 2017年 pingan. All rights reserved.
//

import Foundation


struct PAUtil {
    
    /// 将字符串数组拆解为字符串
    ///
    /// - Parameters:
    ///   - strings: 字符串数组
    ///   - connector: 字符串元素之间的连接元素
    static func dismantleStringArray(_ strings: [String], by connector: String = "") -> String {
        let str = strings.reduce("") { (result, i) -> String in
            return result + connector + i
        }
        let index = str.index(str.startIndex, offsetBy: 1)
        return String(str[index...])
    }
    
    
    
}
