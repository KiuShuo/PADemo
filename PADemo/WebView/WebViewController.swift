//
//  WebViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/16.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.frame = view.bounds
        view.backgroundColor = UIColor.green
        view.addSubview(webView)
        webView.navigationDelegate = self
        let request = URLRequest(url: urlEncode()!)
        webView.load(request)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let request = URLRequest(url: urlEncode()!)
        webView.load(request)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        let request = URLRequest(url: urlEncode()!)
        webView.load(request)
    }
    
    func getSubViews(view: UIView) {
        for subView in view.subviews {
            if subView.subviews.count > 0 {
                getSubViews(view: subView)
            } else {
                print("subView = \(subView)")
            }
        }
    }
    
    // url编码
    func urlEncode() -> URL? {
        let urlString = "https://www.baidu.com/s?wd=百度"
        if let encodeUrlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            debugLog("encodeUrlStr = \(encodeUrlStr)")
            if let decodeUrlString = encodeUrlStr.removingPercentEncoding {
                debugLog("decodeUrlString = \(decodeUrlString)")
            }
            return URL(string: encodeUrlStr)
        }
        return URL(string: urlString)
    }

}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        print("decidePolicyFor navigationAction")
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        print("decidePolicyFor navigationResponse")
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.background='#FF6602'", completionHandler: nil)
        print("didStartProvisionalNavigation navigation")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.background='#FF6602'", completionHandler: nil)
        print("didFailProvisionalNavigation navigation")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit navigation")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.background='#FF6602'", completionHandler: nil)
        print("didFinish navigation")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print("didFail navigation")
    }
    
}
