//
//  PABaseNavigationController.swift
//  wanjia2B
//
//  Created by wujianfeng on 17/3/22.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

typealias CustomLeftBackButtonAction  = (() -> Void)

class PABaseNavigationController: UINavigationController {
    
    var isPushing: Bool = false
    
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
            viewController.navigationItem.setLeftBarButton(self.customLeftBackButton(clickAction: nil), animated: true)
        }
        super.pushViewController(viewController, animated: animated)
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
        button.frame = CGRect(x: 0, y: 0, width: 30.0, height: 18.0)
        button.addClickEvent {
            if let clickAction = clickAction {
                clickAction()
            } else {
                _ = self.popViewController(animated: true)
            }
        }
        button.setImage(UIImage(named:"leftBackButton"), for: .normal)
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = .left
        // 让按钮的内容往左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        let backButton = UIBarButtonItem(customView: button)
        return backButton
    }
}




