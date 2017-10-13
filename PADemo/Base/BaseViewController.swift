//
//  BaseViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/11.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.paBackground
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
//        navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
    
    deinit {
        print(String(describing: self.classForCoder) + "析构方法执行")
    }
    
}
