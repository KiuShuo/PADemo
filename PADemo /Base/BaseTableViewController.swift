//
//  BaseTableViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/31.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.paBackground
    }
    
    deinit {
        print(String(describing: self.classForCoder) + "析构方法执行")
    }
    
}
