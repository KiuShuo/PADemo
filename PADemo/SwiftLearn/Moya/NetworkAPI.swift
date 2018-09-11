//
//  API.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import Moya

public protocol TargetProtocol: TargetType {
    //
}

// 参数统一处理，每个模块根据需要进行重写
public extension TargetProtocol {
    
    var baseURL: URL {
        return URL.init(string:"https://gw.pinganwj.com/")!
    }
    
    var method: Moya.Method {
        return Moya.Method.post
    }
    
    var path: String {
        return "wanjia/app.do"
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
