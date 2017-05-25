//
//  NotificationCenterController.swift
//  PADemo
//
//  Created by shuo on 2017/5/3.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

// 参考资料
// iOS NSNotificationCenter 使用姿势详解 http://www.jianshu.com/p/a4d519e4e0d5
// 从 iOS 9 NSNotificationCenter 无需手动移除观察者说起 http://www.jianshu.com/p/7925a00ec739

/**
 Q1. NotificationCenter 添加的通知是否需要手动移除？
 
 结论：iOS9之后不需要，之前需要。
 
 原因：
 
 注册观察者时，通知中心不会对观察者做retain操作；
 iOS9之前，是做了不安全引用 unsafe_unretained；iOS9之后，是做了弱引用 weak；
 观察者注册时，通知中心并不会对观察者对象做 retain 操作，而是对观察者对象进行unsafe_unretained 引用。
 
 不安全引用（unsafe reference）和弱引用 (weak reference) 类似，它并不会让被引用的对象保持存活，但是和弱引用不同的是，当被引用的对象释放的时，不安全引用并不会自动被置为 nil，这就意味着它变成了野指针，而对野指针发送消息会导致程序崩溃。
 
 因此，iOS9之前，观察者对象在释放之前必须从通知中心移除引用，否则通知中心就会给野指针所引用的对象发送消息，导致程序崩溃。
 iOS9之后，不移除没有问题。
 
 Q2. viewController里添加的通知，在viewController deinit时是否需要手动移除？
 
 结论：iOS8之后不需要。
 
 至少在iOS8之后（因为没有iOS7的测试机），在viewController里面添加一个通知，当viewController销毁的时候系统会自动的执行removeObserver方法。
 即 iOS8之后在viewController里面添加的通知，在viewController释放的时候如果没有手动执行removeObserver方法是没有问题的。
 
 Q3. 通知是同步的吗？子线程中发送的通知 方法是在哪个线程执行的？
 
 答：通知是同步的，在哪个线程发出的通知，就在哪个线程执行方法。
 
 NSNotificationCenter消息的接受线程是基于发送消息的线程的。也就是同步的，因此，有时候，你发送的消息可能不在主线程，而大家都知道操作UI必须在主线程，不然会出现不响应的情况。所以，在你收到消息通知的时候，注意选择你要执行的线程。
 
 */


// 建议还是要手动移除

class NotificationCenterController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let model = PATestModel()
        model.addObserver()
        // 执行完上面的代码之后，由于model没有人持有，所以释放掉了
        
        //NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name(rawValue: "NotificationTest"), object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // POINT 2
        // 对于 iOS 9之前，这样写会crash；iOS9之后包括iOS9这样写都没有问题
        // iOS9之前，向一个已经释放掉的对象发送通知，会crash
        // iOS9之后，系统做了优化
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationTestAAA"), object: nil)
    }
    
    deinit {
        debugLog("析构方法执行")
    }

}


class PATestModel: NSObject {
    
    override init() {
        super.init()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name(rawValue: "NotificationTestAAA"), object: nil)
    }
    
    @objc func test() {
        debugLog("test")
    }
    
    deinit {
        debugLog("执行")
    }
    
}
