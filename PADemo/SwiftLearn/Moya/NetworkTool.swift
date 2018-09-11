//
//  NetworkTool.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import Alamofire

class NetworkTool {
    
    static let tool = NetworkTool()
    
    private init() {}
    
    var isNetworkConnect: Bool {
        get {
            let network = NetworkReachabilityManager()
            return network?.isReachable ?? true
        }
    }
    
}
