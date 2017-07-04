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
 
1. setNeedsLayout 会给当前 UIView 立一个 flag，以表示后续应该调用 layoutSubviews 方法，以调整当前视图及其子视图的布局。
2. setNeedsDisplayInRect: 会给当前 UIView 立一个 flag，以表示后续应该调用 drawRect: 方法，以进行视图重绘。

 
 
 layoutSubViews的执行时机：
 
 1.初始化不会触发layoutSubviews，但是如果设置了不为CGRectZero的frame的时候就会触发。
 2.addSubview会触发layoutSubviews
 3.设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4.滚动一个UIScrollView会触发layoutSubviews
 5.旋转Screen会触发父UIView上的layoutSubviews事件
 6.改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 
 在苹果的官方文档中强调:
 当我们在某个类的内部调整子视图位置时，需要调用。反过来的意思就是说：如果你想要在外部设置subviews的位置，就不要重写。
 开发者不应该直接调用 layoutSubviews 与  drawRect: ，而应该在你认为系统默认的布局和重绘不能带给你想要的效果时，在子类中重写这些方法，然后分别通过 setNeedsLayout 和 setNeedsDisplayInRect: 来进行调用。
 

 
 
 http://www.cocoachina.com/ios/20160530/16522.html
 http://www.jianshu.com/p/e1eca032be15
 http://www.jianshu.com/p/eb2c4bb4e3f1
 */


class MasonryViewController: BaseViewController {
    
    let button = PADButton(type: .custom)
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 通过改变约束来实现动画效果
        
        self.button.mas_updateConstraints { (make) in
            make!.top.equalTo()(200)
        }
        // 更新（或者添加）约束只是执行了setNeedsLayout 标记了需要重新布局，但是没有立即执行。所以我们需要在动画中调用这个方法layoutIfNeeded
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupButton() {
        /*
         // 1.初始化不会触发layoutSubviews，但是如果设置了不为CGRectZero的frame的时候就会触发。
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
         */
        view.addSubview(button)
        /*
         // 2.addSubview会触发layoutSubviews
        let buttonSubView = UIView()
        button.addSubview(buttonSubView)
        buttonSubView.removeFromSuperview()
        */
        
//        button.addTarget(self, action: #selector(clickBt), for: .touchUpInside)
//        button.setTitle("点击我", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.backgroundColor = UIColor.orange
//        button.mas_makeConstraints { (make) in
//            make!.left.top().equalTo()(100)
//            make!.width.equalTo()(100)
//            make!.height.equalTo()(26)
//        }
        // 添加过约束后，只是做了setNeedsLayout标记，所以并不会发生改变，因此此时的frame为CGRect.zero
//        print("buttonFrame = \(button.frame)")
        
        /**
         view.layoutIfNeeded()
         print("buttonFrame = \(button.frame)")
         */
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        print("buttonFrame = \(button.frame)")
    }

}

class PADButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
    }
    
}
