//
//  Protocol.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerMaker {
    
    // associatedtype T
    static func makeViewController(viewControllerClass: BaseViewController.Type) -> UIViewController
    
}

