//
//  AlertCustomView.swift
//  PADemo
//
//  Created by shuo on 2017/8/16.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

extension PAAlertView {
    
    static func integrationAlert(sureTitle: String = "立即转换", sureActionHadel: @escaping ((PAAlertView) -> Void)) {
        let alertView = PAAlertView()
        let sureAction = PAAlertViewAction(title: sureTitle) { _ in
            sureActionHadel(alertView)
        }
        sureAction.isAutoDismissAlertView = false
        alertView.addAction(sureAction)
        alertView.onlyFillCustomView = true
        let customView = PAIntegrationAlertCustomView.instanceFromXib()
        alertView.addKeyboardNotification()
        customView.frame = CGRect(x: 0, y: 0, width: 0, height: 55)
        alertView.addCustomView(view: customView)
        alertView.show {
            customView.textField.becomeFirstResponder()
        }
    }
}

class PAIntegrationAlertCustomView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
    class func instanceFromXib() -> PAIntegrationAlertCustomView {
        let view = Bundle.main.loadNibNamed("AlertCustuomView", owner: nil, options: nil)?.first as! PAIntegrationAlertCustomView
        //view.backgroundColor = UIColor.green
        return view
    }
    
}
