//
//  CustomNavigationItemController.swift
//  PADemo
//
//  Created by shuo on 2017/5/11.
//  Copyright © 2017年 shuo. All rights reserved.
//  自定义导航上的item，并自由的控制item之间的间距、位置

import UIKit

class CustomNavigationItemController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = customNavigationItem()
        let closeItem = closeNavigationItem()
        navigationItem.setLeftBarButtonItems([backItem, blankItem(), closeItem], animated: true)
    }
    
    func customNavigationItem() -> UIBarButtonItem {
        let backBt = UIButton(type: .custom)
        backBt.frame = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        backBt.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backBt.setImage(#imageLiteral(resourceName: "leftBackButton"), for: .normal)
//        backBt.backgroundColor = UIColor.yellow
        let backItem = UIBarButtonItem(customView: backBt)
        return backItem
    }
    
    func closeNavigationItem() -> UIBarButtonItem {
        let closeBt = UIButton(type: .custom)
        closeBt.frame = CGRect(x: 0, y: 0, width: 40.0, height: 30.0)
        closeBt.setTitle("关闭", for: .normal)
//        closeBt.backgroundColor = UIColor.green
        closeBt.setTitleColor(UIColor.black, for: .normal)
        closeBt.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeBt)
        return closeItem
    }
    
    func blankItem() -> UIBarButtonItem {
        let blankView = UIView()
        blankView.frame = CGRect(x: 0, y: 0, width: 1.0, height: 30.0)
//        blankView.backgroundColor = UIColor.red
        let closeItem = UIBarButtonItem(customView: blankView)
        return closeItem
    }

    func close() {
        debugLog("点击关闭按钮")
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

