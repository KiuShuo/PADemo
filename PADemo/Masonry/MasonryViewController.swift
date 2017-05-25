//
//  MasonryViewController.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import Masonry

class MasonryViewController: BaseViewController  {
    
    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        setupButton()
    }
    
    func setupButton() {
        view.addSubview(button)
        button.setTitle("点击我", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.orange
        button.mas_makeConstraints { (make) in
            make!.left.top().equalTo()(100)
            make!.width.equalTo()(100)
            make!.height.equalTo()(26)
        }
    }

}
