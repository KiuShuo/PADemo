//
//  TextFieldDetailViewController.swift
//  PADemo
//
//  Created by shuo on 2017/6/20.
//  Copyright © 2017年 shuo. All rights reserved.
//

/**
 1. 当界面上没有键盘时，如果调用键盘消失的方法，是不会执行键盘消失的通知的。
 2. 
 
 */

import UIKit

class TextFieldDetailViewController: BaseViewController {
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.placeholder = "lalal"
        print("textField will becomeFirstResponder")
        // fix 2
        textField.becomeFirstResponder()
        print("textField had becomeFirstResponder")
        // fix 3
        self.view.addSubview(textField)
        textField.mas_makeConstraints { (make) in
            make!.centerX.equalTo()
            make!.centerY.equalTo()
            make!.width.equalTo()(self.view.frame.width / 3)
        }
        
        print("textField finished")
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("viewDidLoad \(textField)")
        
        print("begin add notification")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDismiss(_ :)), name: .UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_ :)), name: .UIKeyboardDidShow, object: nil)
        print("finish add notification")
        
        
        
    }
    // 执行顺序 viewDidLoad() -> viewDiaAppear(_ :)
    
    // 注释fix 1/2/3 中的任何一行代码都可以解决循环引用的问题
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("viewDidAppear \(textField)")
        super.viewDidAppear(animated)
        // fix 1
        print("viewDidAppear start")
//        print("viewDidAppear \(textField)")
        
        
//        defer {
//            print("viewDidLoad \(textField)")
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    // 上一个界面的键盘什么时候消失？ 注释fix1 发现 当本届还未定义textField时，上一个界面的键盘就消失了。
    @objc func keyboardDismiss(_ info: Notification) {
        if let frame = (info.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue {
            print("消失键盘的高度： \(frame.size.width)")
        }
        // fix 4
        print("dismiss keyboard )")
    }
    
    @objc func keyboardShow(_ info: Notification) {
        if let frame = (info.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue {
            print("弹出键盘的高度： \(frame.size.width)")
        }
        print("show keyboard")
    }

}
