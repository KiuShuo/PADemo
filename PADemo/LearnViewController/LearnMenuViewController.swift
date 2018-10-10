//
//  LearnMenuViewController.swift
//  PADemo
//
//  Created by shuo on 2017/10/25.
//  Copyright © 2017年 shuo. All rights reserved.
//


/*
 参考资料： https://my.oschina.net/u/2340880/blog/653818
 
 UIMenuController的展现需要基于一个View视图，其交互则需要基于其所在View视图的Responder。举例来说，如果一个UIMenuController展现在当前ViewController的View上，则此UIMenuController的交互逻辑交由当前的ViewController进行管理。
 
 在界面展示出UIMenuController需要3个条件：
 
 1.当前的Responder处于第一响应。
 
 2.UIMenuController对象调用menuVisible方法。
 
 3.当前的Responder实现了如下两个方法：
 */
import UIKit
import MBProgressHUD

class LearnMenuViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapLabel()
        learnTextView()
        paNavigationBarHidden = true
    }
    
    func setupTapLabel() {
        let menuLabel = UILabel()
        menuLabel.frame = CGRect(x: 50, y: 150, width: 200, height: 100)
        view.addSubview(menuLabel)
        menuLabel.text = "hahahah"
        menuLabel.textColor = UIColor.black
        menuLabel.backgroundColor = UIColor.green
        menuLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMenuController(_:)))
        menuLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func showMenuController(_ recognizer: UIGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            return
        }
        //        becomeFirstResponder()
        let menuController = UIMenuController.shared
        if let menuCont = menuController.menuItems?.count, menuCont > 0 {
            menuController.setMenuVisible(!menuController.isMenuVisible, animated: true)
            return
        }
        menuController.arrowDirection = .down
        menuController.setTargetRect(CGRect.zero, in: recognizerView)
        let menuItem0 = UIMenuItem(title: "doSomething", action: #selector(doSomething))
        let menuItem1 = UIMenuItem(title: "doSomething", action: #selector(doSomething))
        let menuItem2 = UIMenuItem(title: "doSomething", action: #selector(doSomething))
        let menuItem3 = UIMenuItem(title: "doSomething", action: #selector(doSomething))
        let menuItem4 = UIMenuItem(title: "doSomething", action: #selector(doSomething))
        menuController.menuItems = [menuItem0, menuItem1, menuItem2, menuItem3, menuItem4]
        menuController.setMenuVisible(true, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func doSomething() {
        print("doSomething")
    }
    
    let textView = UILabel() //frame: CGRect(x: 10, y: 300, width: 350, height: 0))
    func learnTextView() {
        textView.numberOfLines = 0
        textView.backgroundColor = UIColor.green
        let detailDescribe = "1.上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情上评详情\n2.上评详情上评详情上评详情上评详情;\n3.上评详情上评详情上评详情上评详情\n4.上评详情上评详情上评详情上评详情\n5.上评详情上评详情上评详情上评详情\n6.上评详情上评详情上评详情上评详情"
        let mAttributedString = NSMutableAttributedString(string: detailDescribe)
        
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = 3
        style.lineSpacing = 1.8
        let length = detailDescribe.count
        let range = NSMakeRange(0, length)
        mAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        textView.attributedText = mAttributedString
        view.addSubview(textView)
        textView.mas_makeConstraints { (make) in
            make!.left.equalTo()(10)
            make!.right.equalTo()(-10)
            make!.top.equalTo()(300)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        if textView.numberOfLines == 0 {
//           textView.numberOfLines = 6
//        } else {
//            textView.numberOfLines = 0
//        }
        testMBProgressHUD()
    }
    
    func testMBProgressHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.backgroundColor = UIColor.green
//        hud?.autoresizingMask = []
//        hud?.frame.origin.y += 64
//        hud.offset.y = 64
//        hud?.mas_remakeConstraints { (make) in
//            make!.top.equalTo()(64)
//            make!.left.right().bottom().equalTo()
//        }
//        hud?.hide(true, afterDelay: 6)
    }
    
}

