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
    
    var context: JSContext!
}

extension KSUIWebViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let aContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            context = aContext
        }
        
        // 原生调用JS
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
    }
    
}
