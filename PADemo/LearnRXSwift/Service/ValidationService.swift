//
//  ValidationService.swift
//  PADemo
//
//  Created by shuo on 2018/1/4.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Result {
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension Result {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension Result {
    var textColor: UIColor {
        switch self {
        case .ok:
            return .green
        case .empty:
            return .black
        case .failed:
            return .red
        }
    }
}

extension Result {
    var description: String {
        switch self {
        case .ok(let message):
            return message
        case .empty:
            return ""
        case .failed(let message):
            return message
        }
    }
}

// 验证 服务 类
class ValidationService {
    
    static let instance = ValidationService()
    
    private init() {}
    
    let minCharactersCount = 6
    
    /*
     // 验证注册时输入的用户名是否有效
     返回一个Observable对象 用于username变化时可以被监听到
     just 创建一个sequence只能发出一种特定事件，能正常结束
     */
    func validateUsername(_ username: String) -> Observable<Result> {
        if username.isEmpty {
            return Observable.just(.empty)
        }
        if username.count < minCharactersCount {
            return Observable.just(.failed(message: "用户名长度必须大于\(minCharactersCount)"))
        }
        if usernameValid(username) {
            return Observable.just(.failed(message: "用户名已存在"))
        }
        return Observable.just(.ok(message: "用户名可用"))
    }
    
    // 判断userName是否存在
    func usernameValid(_ username: String) -> Bool {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        guard let usernameArr = userDic?.allKeys as? [String] else {
            return false
        }
        return usernameArr.contains(username)
    }
    
    // 校验输入的密码是否正确
    func validatePassword(_ password: String) -> Result {
        if password.isEmpty {
            return .empty
        }
        if password.count < minCharactersCount {
            return .failed(message: "密码长度必须大于\(minCharactersCount)")
        }
        return .ok(message: "密码正确")
    }
    
    // 对比两次输入的密码是否一致
    func validateRepeatPassword(_ password: String, _ repeatPassword: String) -> Result {
        if repeatPassword.isEmpty {
            return .empty
        }
        if password == repeatPassword {
            return .ok(message: "密码正确")
        }
        return .failed(message: "两次输入的密码不一致")
    }
    
}
