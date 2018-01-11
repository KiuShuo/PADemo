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
            return Observable.just(.failed(message: "用户名长度必须大于6"))
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
    
}
