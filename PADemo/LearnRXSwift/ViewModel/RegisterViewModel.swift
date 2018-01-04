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
    
}
