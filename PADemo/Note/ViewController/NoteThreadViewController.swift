//
//  NoteThreadViewController.swift
//  PADemo
//
//  Created by shuo on 2018/3/6.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class NoteThreadViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var queue: DispatchQueue?
    
    @IBAction func clickConcurrentQueue(_ sender: Any) {
        queue = DispatchQueue(label: "aConcurrentQueue", attributes: DispatchQueue.Attributes.concurrent)
    }
    
    @IBAction func clickSerialQueue(_ sender: Any) {
        queue = DispatchQueue(label: "aSerialQueue")
    }
    
    @IBAction func clickAsync(_ sender: Any) {
        for i in 0...10 {
            queue?.async {
                print("\(i) current thread = \(Thread.current)")
            }
        }
    }
    
    @IBAction func clickSync(_ sender: Any) {
        for i in 0...10 {
            queue?.sync {
                print("\(i) current thread = \(Thread.current)")
            }
        }
    }
    
}
