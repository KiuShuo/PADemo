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
 #
 #### Q1. NotificationCenter 添加的通知是否需要手动移除？
 结论：iOS8开始添加到UIViewController的通知，不需要手动移除，iOS9之后添加到NSObject的通知也不需要手动移除。
 至少在iOS8之后（因为没有iOS7的测试机），在viewController里面添加一个通知，当viewController销毁的时候系统会自动的执行removeObserver方法。
 即 iOS8之后在viewController里面添加的通知，在viewController释放的时候如果没有手动执行removeObserver方法是没有问题的。
 从iOS9开发，NSObject也可以像UIViewController一样，在delloc的时候自动的移除通知
 原因：
 注册观察者时，通知中心不会对观察者做retain操作；
 iOS9之前，是做了不安全引用 unsafe_unretained；iOS9之后，是做了弱引用 weak。
 不安全引用（unsafe reference）和弱引用 (weak reference) 类似，它并不会让被引用的对象保持存活，但是和弱引用不同的是，当被引用的对象释放的时，不安全引用并不会自动被置为 nil，这就意味着它变成了野指针，而对野指针发送消息会导致程序崩溃。
 因此，iOS9之前，观察者对象在释放之前必须从通知中心移除引用，否则通知中心就会给野指针所引用的对象发送消息，导致程序崩溃。
 iOS9之后，不移除没有问题。
 ##### Q2. 通知是同步的吗？子线程中发送的通知 方法是在哪个线程执行的？
 答：通知是同步的，在哪个线程发出的通知，就在哪个线程执行方法。
 NSNotificationCenter消息的接收线程是基于发送消息的线程的，也就是同步的。因此，有时候，你发送的消息可能不在主线程，而大家都知道操作UI必须在主线程，不然会出现不响应的情况。所以，在你收到消息通知的时候，注意选择你要执行的线程。
 */

// 建议还是要手动移除

class NotificationCenterController: BaseViewController, NSMachPortDelegate {
    var notifications: [Notification] = []
    var notificationThread = Thread.current
    var notificationLock = NSLock()
    var notificationPort = NSMachPort()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let model = PATestModel()
        model.addObserver()
        // 执行完上面的代码之后，由于model没有人持有，所以释放掉了
        
        // NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name(rawValue: "NotificationTest"), object: nil)
        
        //        notificationPort.setDelegate(self)
        //        RunLoop.current.add(notificationPort, forMode: RunLoopMode.commonModes)
        //        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: NSNotification.Name.init("TestNotification"), object: nil)
        //        DispatchQueue.global().async {
        //            NotificationCenter.default.post(name: NSNotification.Name.init("TestNotification"), object: nil)
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // POINT 2
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationTestAAA"), object: nil)
    }
    
    deinit {
        debugLog("析构方法执行")
    }
    
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        notificationLock.lock()
        while notifications.count > 0 {
            guard let notification = notifications.first else {
                break
            }
            notifications.remove(at: 0)
            notificationLock.unlock()
            processNotification(notification: notification)
            notificationLock.lock()
        }
        notificationLock.unlock()
    }
    
    @objc func processNotification(notification: Notification) {
        if Thread.current != notificationThread {
            notificationLock.lock()
            notifications.append(notification)
            notificationLock.unlock()
            notificationPort.send(before: Date(), components: nil, from: nil, reserved: 0)
        } else {
            print("current thread = \(Thread.current)")
        }
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

