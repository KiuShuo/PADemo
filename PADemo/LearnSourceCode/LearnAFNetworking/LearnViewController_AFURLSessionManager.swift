//
//  LearnViewController_AFURLSessionManager.swift
//  PADemo
//
//  Created by shuo on 2018/12/4.
//  Copyright © 2018 shuo. All rights reserved.
//

import UIKit
import AFNetworking

class LearnViewController_AFURLSessionManager: BaseViewController {

    let httpImageUrl = "http://www.hangge.com/blog_uploads/201512/2015121920180529333.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clickButton(_ sender: UIButton) {
        //
    }
    
    func doAFRequest() {
        let configuration = URLSessionConfiguration.default
        let manager = AFURLSessionManager.init(sessionConfiguration: configuration)
        // 设置网络请求序列化对象
        let requestSerializer = AFHTTPRequestSerializer()
        requestSerializer.setValue("test", forHTTPHeaderField: "requestHeader")
        requestSerializer.timeoutInterval = 60
        requestSerializer.stringEncoding = String.Encoding.utf8.rawValue
        // 设置返回数据序列化对象
        let responseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = responseSerializer
        // 网络请求安全策略
        let isCustomSecurityPolicy = true
        if isCustomSecurityPolicy {
            let securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.publicKey)
            securityPolicy.allowInvalidCertificates = false
            securityPolicy.validatesDomainName = true
            manager.securityPolicy = securityPolicy
        } else {
            manager.securityPolicy.allowInvalidCertificates = true
            manager.securityPolicy.validatesDomainName = false
        }
        // 是否允许请求重定向
        let isNeedRedirectionRequest = true
        if isNeedRedirectionRequest {
            manager.setTaskWillPerformHTTPRedirectionBlock { (session, sessionTask, response, request) -> URLRequest? in
                return request
            }
        }
        // 监听网络状态
        manager.reachabilityManager.setReachabilityStatusChange { (networkReachabilityStatus) in
            print("networkReachabilityStatus = \(networkReachabilityStatus)")
        }
        manager.reachabilityManager.startMonitoring()
        
        guard let url = URL(string: httpImageUrl) else {
            return
        }
        let request = URLRequest(url: url)
        let downloadTask = manager.downloadTask(with: request, progress: { (progress) in
            print("progress = \(progress)")
        }, destination: { (url, response) -> URL in
            var documentDirectoryURL: URL?
            do {
                documentDirectoryURL = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            } catch let error {
                print("error = \(error.localizedDescription)")
            }
            if let fileName = response.suggestedFilename,
                let fileURL = documentDirectoryURL?.appendingPathComponent(fileName) {
                return fileURL
            }
            print("url = \(url), response = \(response)")
            return URL(string: "")!
        }) { (response, url, error) in
            print("response = \(response), url = \(String(describing: url)), error = \(error?.localizedDescription ?? "")")
        }
        downloadTask.resume()
    }

}

