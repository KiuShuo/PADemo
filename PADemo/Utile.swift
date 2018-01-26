//
//  Utile.swift
//  PADemo
//
//  Created by shuo on 2017/5/3.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation


func debugLog(_ items: Any..., file: String = #file, line: Int = #line, funcName: String = #function) {
    // mas 1
    // mas 2
    let fileName: String = (file.components(separatedBy: "/").last ?? "").components(separatedBy: ".").first ?? ""
    debugPrint("file: \(fileName), line: \(line), func: \(funcName)")
    if !items.isEmpty {
        print(items)
    }
    // jin 1
}
