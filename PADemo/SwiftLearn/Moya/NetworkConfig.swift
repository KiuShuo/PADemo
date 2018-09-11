//
//  NetworkConfig.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import Moya
import Alamofire

class NetworkConfig {
    
    var endpointClosure = { (target: TargetProtocol) -> Endpoint in
        let url = target.baseURL.absoluteString + target.path
        var task = target.task
        var endpoint = Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: task,
            httpHeaderFields: target.headers)
        return endpoint
    }
    
    var requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 30
            if let requestData = request.httpBody {
                print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
            } else {
                print("\(request.url!)"+"\(String(describing: request.httpMethod))")
            }
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    var serverTrustPolicys: [String: ServerTrustPolicy] {
        var certificates: [SecCertificate] = []
        if let certificateData = decodeBase64ToData(PAPinganwjCer.kpinganwjKey),
            let certificate = SecCertificateCreateWithData(nil, certificateData) {
            certificates.append(certificate)
        }
        let policy = ServerTrustPolicy.pinCertificates(certificates: certificates, validateCertificateChain: false, validateHost: true)
        return ["gw.pinganwj.com": policy]
    }
    
    let networkPlugin = NetworkActivityPlugin.init { (changeType, TargetProtocol) in
        switch(changeType){
        case .began:
            print("开始请求网络")
        case .ended:
            print("结束")
        }
    }
    
}
