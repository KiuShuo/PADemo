//
//  RegisterViewModel.swift
//  PADemo
//
//  Created by shuo on 2018/1/4.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    // Variable 是subject的一种(subject的特点：既是一个Observable也是一个Observer，既可以发出事件也可以监听事件)
    var username = Variable<String>("") // 初始值为""
    // 对username的处理应该有一个结果，通过监听这个结果来改变界面，所以定义为Observable
    let usernameUsable: Observable<Result>
    
    init() {
        let service = ValidationService.instance
        /**
         username作为Observable被观察者
         因为需要根据用户名Observable返回一个处理结果作为新的Obasevable，所以使用变换操作map
         flatMapLatest相较于其他几个的特点是：只会接受最新的value事件
         service.validateUsername(username) 获取新的Observable
         observeOn 设置后续工作在哪个线程；observeOn(MainScheduler.instance) 设置后续工作在主线程中进行
         catchErrorJustReturn 预计error的时候就返回一个值，然后结束
         */
        usernameUsable = username.asObservable()
            .flatMapLatest { username in
                return service.validateUsername(username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "username检测出错"))
            }.share(replay: 1)
        
    }
    
}
