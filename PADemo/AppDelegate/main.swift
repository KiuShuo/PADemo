//
//  main.swift
//  PADemo
//
//  Created by shuo on 2018/5/2.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit
import Foundation

let startTime = CFAbsoluteTimeGetCurrent()

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    nil,
    NSStringFromClass(AppDelegate.self)
)

let space1 = CFAbsoluteTimeGetCurrent() - startTime

print("space1 = \(space1)")

