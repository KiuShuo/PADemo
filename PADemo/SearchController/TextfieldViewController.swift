//
//  TextfieldViewController.swift
//  PADemo
//
//  Created by shuo on 2017/6/20.
//  Copyright © 2017年 shuo. All rights reserved.
//

/**
 系统处理：当从A push到 B时，如果A界面中有键盘，会先将键盘dismiss掉，当从B界面返回时，会重新弹出键盘.
 */

import UIKit
import Masonry

class TextfieldViewController: BaseViewController {
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.keyboardType = .decimalPad
        textField.placeholder = "lalal"
        return textField
    }()
    
    var pushToDetailButton: PAButton = {
        let button = PAButton()
        button.setTitle("详情", for: .normal)
        button.backgroundColor = UIColor.green
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupPushToDetailButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("textfield viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("textfield viewDidDisappear")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    func setupPushToDetailButton() {
        view.addSubview(pushToDetailButton)
        
        pushToDetailButton.mas_makeConstraints { (make) in
            make!.centerX.equalTo()
            make!.top.equalTo()(self.textField.mas_bottom)?.offset()(10)
            make!.width.equalTo()(60)
        }
        
        pushToDetailButton.addClickEvent { [weak self] in
            guard let `self` = self else { return }
            let detailVC = TextFieldDetailViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    func setupTextField() {
        view.addSubview(textField)
        
        textField.mas_makeConstraints { (make) in
            make!.centerX.equalTo()
            make!.centerY.equalTo()
            make!.width.equalTo()(self.view.frame.width / 3)
        }
    }
    
    
    
}
