//
//  API.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import Moya

enum AModuleNetworkAPI {
    case wjRequest(params: [String: Any])
}

extension AModuleNetworkAPI: TargetType {
    
    var task: Task {
        switch self {
        case .wjRequest(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
}

// 参数统一处理，每个模块根据需要进行重写
public extension TargetType {
    
    // baseURL不依赖于self(当前枚举)的值，而应该单独返回单个值
    var baseURL: URL {
        return URL.init(string:"https://gw.pinganwj.com")!
    }
    
    var method: Moya.Method {
        return Moya.Method.post
    }
    // API端点相对于baseURL的位置
    var path: String {
        return "/wanjia/app.do"
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
