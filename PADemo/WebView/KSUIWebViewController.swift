//
//  KSUIWebViewController.swift
//  PADemo
//
//  Created by shuo on 2018/3/8.
//  Copyright © 2018年 shuo. All rights reserved.
//  JS与native交互 注意JS与native的相互交互不一定非得有webview的存在，这里之所以用是为了演示JS调用原生时的方便直观

import UIKit
import JavaScriptCore

class KSUIWebViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = view.bounds
        view.addSubview(webView)
        
        guard let filepath = Bundle.main.path(forResource: "test", ofType: "html") else {
            return
        }
        let url = URL(fileURLWithPath: filepath)
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        webView.delegate = self
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
    
    var context: JSContext!
    
    // 使用JavaScript实现js与native的交互
    func useJavaScriptCore() {
        // 原生调用JS
//        let context = JSContext()
        context.evaluateScript("var num = 5 + 5")
        context.evaluateScript("var names = ['Grace', 'Ada', 'Margaret']")
        context.evaluateScript("var triple = function(value) { return value * 3 }")
        let tripleNum: JSValue = context.evaluateScript("triple(num)")
        print(tripleNum.toNumber().intValue)
        
        let jsValue = context.objectForKeyedSubscript("sumValue")
        let resultValue = jsValue?.call(withArguments: [1, 2])
        let result = resultValue?.toInt32()
        print("retult = \(result ?? 0)")
        
        // JS调用原生
        let nativeLog: @convention(block) (String) -> Void = { str in
            print("str = \(str)")
        }
        // unsafeBitCast用来强制类型转换 使用的时候需要明确的知道要转换的类型
        let nativeLogObject = unsafeBitCast(nativeLog, to: AnyObject.self)
        // setObject(:, forKeyedSubscript:) 为JS添加方法或属性
        context.setObject(nativeLogObject, forKeyedSubscript: "nslog" as NSCopying & NSObjectProtocol)
        
        let nativeShare: @convention(block) (String, String, String) -> Void = { (title, imgUrl, link) in
            print("开始分享 \(title), \(imgUrl), \(link)")
        }
        let nativeShareObject = unsafeBitCast(nativeShare, to: AnyObject.self)
        context.setObject(nativeShareObject, forKeyedSubscript: "share" as NSCopying & NSObjectProtocol)
        
        let configureRightNavigationItem: @convention(block) (String) -> Void = { [weak self] itemType in
            print("current thread = \(Thread.current)")
            DispatchQueue.main.async(execute: {
                self?.setupNavigationRightItemButton(type: itemType)
            })
        }
        let configureRightNavigationItemCovent = unsafeBitCast(configureRightNavigationItem, to: AnyObject.self)
        context.setObject(configureRightNavigationItemCovent, forKeyedSubscript: "addNavigationRightItem" as NSCopying & NSObjectProtocol)
    }
    
}

extension KSUIWebViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let aContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            context = aContext
        }
        useJavaScriptCore()
    }
    
    
    func chongdingxiangjiaohu(urlString: String) {
        let components = urlString.components(separatedBy: "://")
        if components.count > 1 {
            let funcName = components[1].components(separatedBy: "?").first
            let params = queryComponents(urlStr: urlString)
            print("funcName = \(funcName ?? ""), params = \(params)")
        }
    }
    
}

func queryComponents(urlStr: String) -> [String: String] {
    var components: [String: String] = [:]
    guard let url = URL(string: urlStr),
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems else {
            return components
    }
    for item in queryItems {
        if !item.name.isEmpty {
            components[item.name] = item.value.noneNull
        }
    }
    return components
}
