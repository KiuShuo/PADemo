//
//  MasonryViewController.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//  Masonry + AutoLayout

import UIKit
import Masonry


/**
 
 updateConstraints 主要作用是更新view的约束，并调用其所有子视图的该方法去更新约束。
 
 
 setNeedsLayout()
 
 layoutIfNeeded()
 
 layoutSubviews()
 
 setNeedsLayout会立一个flag 用来标记视图或者其子视图需要进行布局更新；
 layoutIfNeeded会调用layoutSubviews
 
 */


class MasonryViewController: BaseViewController {
    
    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        setupButton()
    }
    
    func clickBt() {
        debugLog(navigationItem.leftBarButtonItem ?? "")
        let vc = DetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupButton() {
        view.addSubview(button)
        button.addTarget(self, action: #selector(clickBt), for: .touchUpInside)
        button.setTitle("点击我", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.orange
        button.mas_makeConstraints { (make) in
            make!.left.top().equalTo()(100)
            make!.width.equalTo()(100)
            make!.height.equalTo()(26)
        }
        print("buttonFrame = \(button.frame)")
        view.layoutIfNeeded()
//        view.layoutSubviews()
//        view.setNeedsLayout()
        print("buttonFrame = \(button.frame)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("buttonFrame = \(button.frame)")
    }

}
