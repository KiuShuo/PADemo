//
//  PABaseNavigationController.swift
//  feng
//
//  Created by wujianfeng on 17/3/22.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

typealias CustomLeftBackButtonAction  = (() -> Void)

class PABaseNavigationController: UINavigationController {
    
    var isPushing: Bool = false
    
    private var fixedBarbuttonItem: UIBarButtonItem = {
        let fixedItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedItem.width = 8
        return fixedItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if isPushing {
            return
        }else{
            isPushing = true
        }
        debugLog("push to controller = \(viewController)")
        if viewController.navigationItem.leftBarButtonItem == nil ,self.viewControllers.count > 0 {
            viewController.navigationItem.leftBarButtonItem = customLeftBackButton(clickAction: nil)
        }
        super.pushViewController(viewController, animated: animated)
//        if #available(iOS 11.0, *) {
//            for barSubView in navigationBar.subviews {
//                if className(obj: barSubView).contains("BarContentView") {
//                    for temView in barSubView.subviews {
//                        if className(obj: temView).contains("BarStackView") {
//                            temView.frame.origin.x = 8
//                            break
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func className(obj: Any) -> String {
        let name: AnyClass! = object_getClass(obj)
        let className = NSStringFromClass(name)
        return String(className)
    }
    
    func handleNavigationTransition( ) {
        
    }
}

extension PABaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            // ！！！当只有一个视图控制器或者顶部视图控制器模态出一个视图控制器时，是不能滑动的
            if viewControllers.count == 1 ||
                topViewController?.presentedViewController != nil {
                return false
            }
        }
        return true
    }
}

//MARK: - UINavigationControllerDelegate
extension PABaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushing = false
    }
    
}

//MARK: - method
extension PABaseNavigationController {
    
    func customLeftBackButton(clickAction: CustomLeftBackButtonAction?) -> UIBarButtonItem {
        let button = PAButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 32.0, height: 44.0)
        button.addClickEvent {
            if let clickAction = clickAction {
                clickAction()
            } else {
                _ = self.popViewController(animated: true)
            }
        }
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(named:"leftBackButton"), for: .normal)
        return UIBarButtonItem(customView: button)
    }
}
