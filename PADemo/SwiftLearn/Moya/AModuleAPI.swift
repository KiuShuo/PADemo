//
//  AModuleAPI.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//  模块A对应的网络API

import Foundation
import Moya

enum AModuleNetworkAPI {
    case wjRequest(params: [String: Any])
}

extension AModuleNetworkAPI: TargetProtocol {
    
    var task: Task {
        switch self {
        case .wjRequest(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
}
