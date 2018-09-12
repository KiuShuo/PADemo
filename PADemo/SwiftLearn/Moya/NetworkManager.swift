//
//  Manager.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//  Moya不是来提供一个网络访问的代码框架，那是Alamofire的事。Moya是一种构建网络访问和为定义良好的网络目标提供编译时检查的方式。

import Foundation
import Moya
import Alamofire

let provider = MoyaProvider<AModuleNetworkAPI>(
    endpointClosure: MoyaProvider.defaultEndpointMapping,
    requestClosure: requestClosure,
    manager: manager,
    plugins: [networkPlugin],
    trackInflights: false)

// Endpoint存储url HTTP方法 HTTP请求头 task(用来区分上传下载和请求) sampleResponseClosure为单元测试 (默认实现已经满足需求，所以暂时无需实现)
//    var endpointClosure = { (target: TargetType) -> Endpoint in
//        let url = target.baseURL.absoluteString + target.path
//        var task = target.task
//        var endpoint = Endpoint(
//            url: url,
//            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
//            method: target.method,
//            task: task,
//            httpHeaderFields: target.headers)
//        return endpoint
//    }

// 最后编辑网络请求的时机，也可以在此完成网络请求日志的输出，因为这个闭包在request发送网络请求之前每次都会调用
private var requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 修改URLRequest的指定实行，或者提供直到创建request才知道的信息（比如：cookie设置）
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

private var serverTrustPolicys: [String: ServerTrustPolicy] {
    var certificates: [SecCertificate] = []
    if let certificateData = decodeBase64ToData(PAPinganwjCer.kpinganwjKey),
        let certificate = SecCertificateCreateWithData(nil, certificateData) {
        certificates.append(certificate)
    }
    let policy = ServerTrustPolicy.pinCertificates(certificates: certificates, validateCertificateChain: false, validateHost: true)
    return ["gw.pinganwj.com": policy]
}

private let networkPlugin = NetworkActivityPlugin.init { (changeType, TargetType) in
    switch(changeType){
    case .began:
        print("开始请求网络")
    case .ended:
        print("结束")
    }
}

private var manager: Manager {
    let ration = URLSessionConfiguration.default
    ration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
    let manager = Manager(
        configuration: ration,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicys))
    manager.startRequestsImmediately = false
    return manager
}
