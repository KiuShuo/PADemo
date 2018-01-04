//
//  BaseViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/11.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var paNavigationBarHidden: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.paBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(paNavigationBarHidden, animated: animated)
    }
    
    deinit {
        print(String(describing: self.classForCoder) + "析构方法执行")
    }
    
}
