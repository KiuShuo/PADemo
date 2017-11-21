//
//  AlertTestViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/16.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class AlertTestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickIntegrationConvertButton(_ sender: UIButton) {
        PAAlertView.integrationAlert(sureTitle: "立即转换") { (alertView) in
            alertView.dismiss()
        }
        
    }

    @IBAction func clickBaseAlertButton(_ sender: UIButton) {
        PAAlertView.showBaseAlert(title: "基本弹框", message: "我是一个基本弹框", buttonTitle: "确定") { 
            print("点击确定按钮")
        }
    }
    var clickTimes: Int = 0
    @IBAction func clickCustonCoverButton(_ sender: UIButton) {
        showCustomAlert()
    }
    
    func showCustomAlert() {
        let alertView = PAAlertView()
        alertView.canDismissByTapMask = true
        let alertCustomCoverViewDelegate = AlertCustomCoverViewDelegate()
        alertCustomCoverViewDelegate.clickTimes = clickTimes
        alertView.alertCoverViewDelegate = alertCustomCoverViewDelegate
        unowned let weakAlertView = alertView
        let doneAction = PAAlertViewAction(title: "确定") { _ in
            weakAlertView.update()
            alertCustomCoverViewDelegate.clickTimes = self.clickTimes
            self.clickTimes += 1
        }
        doneAction.isAutoDismissAlertView = false
        alertView.addAction(doneAction)
        alertView.show()
    }
    
}

class AlertCustomCoverViewDelegate: PAAlertCoverViewDelegate {
    var clickTimes: Int = 0
    func alertCoverView() -> UIView {
        let view = UIView()
        if clickTimes % 2 == 0 {
            view.backgroundColor = UIColor.green
        } else {
            view.backgroundColor = UIColor.red
        }
        return view
    }
    
    func alertCoverViewHeight() -> CGFloat {
        if clickTimes % 2 == 0 {
            return 150
        }
        return 100
    }
    
}

