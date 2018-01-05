//
//  LRxSwiftViewController.swift
//  PADemo
//
//  Created by shuo on 2018/1/5.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class LRxSwiftViewController: RXBaseViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func begin(_ sender: UIButton) {
        perform(Selector(textField.text!))
    }
    
    @objc func mapLearn() {
        print("123")
    }
    
    func flatMapLearn() {
        //
    }

}
