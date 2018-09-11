//
//  Manager.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import Moya
import Alamofire

//class NetworkManager {

//    static let manager = NetworkManager()

//    private init() {}

    private let config = NetworkConfig()

    private func defaultAlamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: config.serverTrustPolicys))
        
        manager.startRequestsImmediately = false
        return manager
    }
    
    private func provider<T: TargetProtocol>() -> MoyaProvider<T> {
        let provider = MoyaProvider<T>(
            endpointClosure: config.endpointClosure,
            requestClosure: config.requestClosure,
            manager: defaultAlamofireManager(),
            plugins: [config.networkPlugin],
            trackInflights: false)
        return provider
    }
    
    func netWorkRequest<T: TargetProtocol>(_ target: T, completion: @escaping successCallback, failed: failedCallback?, errorResult: errorCallback?) {
        if !NetworkTool.tool.isNetworkConnect {
            return
        }
        provider().request(target) { (result) in
            switch result {
            case let .success(response):
                let paresponse = Response(response: response)
                print("response = \(response)")
            case let .failure(error):
                print("error = \(error)")
            }
        }
    }
    
//}
