//
//  NoteTimerViewController.swift
//  PADemo
//
//  Created by shuo on 2018/2/2.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class NoteTimerViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatScrollView()
    }
    
    func creatScrollView() {
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 100, width: UIScreen.width - 20, height: 100))
        scrollView.backgroundColor = UIColor.green
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width - 20, height: 400))
        contentView.backgroundColor = UIColor.red
        scrollView.contentSize.height = 400
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        creatTimer()
    }
    
    var timer: Timer?
    var i = 0
    
    func creatTimer() {
        if #available(iOS 10.0, *) {
            Timer.ini
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.handelTimerAction()
            }
//            timer?.fire()
//            timer = Timer.init(fire: Date(), interval: 5.0, repeats: true, block: { [weak self] _ in
//                self?.handelTimerAction()
//            })
//            RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
        } else {
            // Fallback on earlier versions
            let timer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(handelTimerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        }
    }
    
    @objc func handelTimerAction() {
        print("timer....")
        i += 1
        if i == 5 {
            timer?.invalidate()
        }
    }

}
