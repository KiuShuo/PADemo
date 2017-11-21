//
//  PABaseAlertView.swift
//  PADemo
//
//  Created by shuo on 2017/11/21.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation

// 常用扩展
extension PAAlertView {
    
    // 一个按钮的alert
    @discardableResult
    static func showBaseAlert(title: String? = nil, message: String? = nil, buttonTitle: String = "确定", clickButton: (() -> Void)? = nil) -> PAAlertView {
        let alertView = PAAlertView(title: title, message: message)
        let doneAction = PAAlertViewAction(title: buttonTitle) { _ in
            if let clickButton = clickButton {
                clickButton()
            }
        }
        alertView.addAction(doneAction)
        alertView.show()
        return alertView
    }
    
    // 两个按钮的alert
    @discardableResult
    static func showBaseAlertWithTwoAction(title: String? = nil, message: String? = nil, cancelButtonStr: String = "取消", sureButtonStr: String = "确定", clickCancelButton: (() -> Void)? = nil, clickSureButton: (() -> Void)? = nil) -> PAAlertView {
        let alertView = PAAlertView(title: title, message: message)
        let cancelAction = PAAlertViewAction(title: cancelButtonStr) { _ in
            if let clickCancelButton = clickCancelButton {
                clickCancelButton()
            }
        }
        alertView.addAction(cancelAction)
        let doneAction = PAAlertViewAction(title: sureButtonStr) { _ in
            if let clickSureButton = clickSureButton {
                clickSureButton()
            }
        }
        alertView.addAction(doneAction)
        alertView.show()
        return alertView
    }
    
    // validateAlertView
    static func validateAlertView(title: String? = nil, message: String? = nil, content: String, cancelButtonStr: String = "取消", sureButtonStr: String = "确定", clickCancelButton: (() -> Void)? = nil, clickSureButton: (() -> Void)? = nil, clickContentButton: (() -> Void)? = nil) -> PAAlertView {
        let alertView = PAAlertView(title: title, message: message)
        
        let cancelAction = PAAlertViewAction(title: cancelButtonStr) { _ in
            if let clickCancelButton = clickCancelButton {
                clickCancelButton()
            }
        }
        cancelAction.buttonTextColor = UIColor.black
        alertView.addAction(cancelAction)
        let doneAction = PAAlertViewAction(title: sureButtonStr) { _ in
            if let clickSureButton = clickSureButton {
                clickSureButton()
            }
        }
        
        let contentButton = PAButton(type: .custom)
        contentButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentButton.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        contentButton.setTitle(content, for: .normal)
        contentButton.setTitleColor(UIColor.paOrange, for: .normal)
        contentButton.setTitleColor(UIColor.paHighOrange, for: .highlighted)
        alertView.addCustomView(view: contentButton)
        contentButton.addClickEvent {
            if let clickContentButton = clickContentButton {
                clickContentButton()
            }
        }
        alertView.addAction(doneAction)
        
        return alertView
    }
    
}
