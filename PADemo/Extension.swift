//
//  Extension.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit



extension UIViewController: ViewControllerMaker {
   
//    static func makeViewController(name: String) -> UIViewController? {
//        if let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
//            if let viewControllerClass = NSClassFromString(nameSpace + "." + name) as? UIViewController.Type {
//                let viewController = viewControllerClass.init()
//                return viewController
//            }
//        }
//        return nil
//    }
//    
//    static func viewControllerClass(with name: String) -> UIViewController.Type? {
//        if let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
//            if let viewControllerClass = NSClassFromString(nameSpace + "." + name) as? UIViewController.Type {
//                return viewControllerClass
//            }
//        }
//        return nil
//    }
//
//    var viewControllerClass: BaseViewController {
//        return UIViewController()
//    }
    
}


extension ViewControllerMaker {
    
    static func makeViewController(viewControllerClass: BaseViewController.Type) -> UIViewController {
        let viewController = viewControllerClass.init()
        return viewController
    }

}
