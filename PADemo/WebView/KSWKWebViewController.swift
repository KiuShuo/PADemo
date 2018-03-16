//
//  KSWKWebViewController.swift
//  PADemo
//
//  Created by shuo on 2018/3/9.
//  Copyright © 2018年 shuo. All rights reserved.
//  WKWebView与JS的交互

import UIKit
import WebKit

class KSWKWebViewController: BaseViewController {

    let wkWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        wkWebView.frame = view.bounds
        view.addSubview(wkWebView)
        wkWebView.navigationDelegate = self
        guard let filepath = Bundle.main.path(forResource: "test", ofType: "html") else {
            return
        }
        let url = URL(fileURLWithPath: filepath)
        let request = URLRequest(url: url)
        wkWebView.load(request)
        
        // WKWebView执行JavaScript脚本
        wkWebView.evaluateJavaScript("1 + 2") { (response, error) in
            let result = response as? Int
            print(result ?? -1)
            print(error ?? "success")
        }
        // Adds a script message handler.
        wkWebView.configuration.userContentController.add(self, name: "share")
        wkWebView.configuration.userContentController.add(self, name: "addShareButton")
    }
    
    // 退出页面之前需要remove掉添加的script message，否则会造成内存泄漏
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            wkWebView.configuration.userContentController.removeScriptMessageHandler(forName: "share")
            wkWebView.configuration.userContentController.removeScriptMessageHandler(forName: "addShareButton")
        }
    }
    
    func setupNavigationRightItemButton(type: String) {
        var rightItemButton: UIBarButtonItem?
        if type == "1" {
            rightItemButton = UIBarButtonItem(title: "分享", style: .done, target: self, action: #selector(doShare))
        } else if type == "2" {
            rightItemButton = UIBarButtonItem(title: "个人中心", style: .done, target: self, action: #selector(goPersonalCenter))
        }
        if let rightItemButton = rightItemButton {
            self.navigationItem.setRightBarButton(rightItemButton, animated: true)
        }
    }
    
    @objc func doShare() {
        print("分享")
    }
    
    @objc func goPersonalCenter() {
        print("区个人中心")
    }
    
    deinit {
        print("执行了")
    }
    
}

extension KSWKWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "share":
            let body = message.body
            print(body)
        case "addShareButton":
            let body = message.body as? [String: String]
            if let itemType = body?["itemType"] {
                setupNavigationRightItemButton(type: itemType)
            }
        default: ()
        }
    }
    
}

extension KSWKWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 加载完页面后调用里面的JS代码
        webView.evaluateJavaScript("sumValue(1, 2)") { (response, error) in
            let result = response as? Int
            print(result ?? -1)
            print(error ?? "success")
        }
    }
    
    
}