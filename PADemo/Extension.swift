//
//  Extension.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

extension UIViewController: ViewControllerMaker {
    
}

extension ViewControllerMaker {
    
    static func makeViewController(viewControllerClass: BaseViewController.Type) -> UIViewController {
        let viewController = viewControllerClass.init()
        return viewController
    }

}
