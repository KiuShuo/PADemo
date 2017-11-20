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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
