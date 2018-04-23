//
//  WebViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/16.
//  Copyright © 2017年 shuo. All rights reserved.
//  WKWebView学习

import UIKit
import WebKit

class WebViewController: BaseViewController {
    var webView: WKWebView!
    var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.paOrange
        progressView.trackTintColor = UIColor.green
        progressView.frame = CGRect(x: 0, y: UIScreen.navigationHeight, width: UIScreen.width, height: 2)
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.frame = view.bounds
        view.backgroundColor = UIColor.green
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.navigationDelegate = self
        let request = URLRequest(url: urlEncode()!)
        webView.load(request)
        setupNavigationItem()
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.5)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if progressView.progress == 1 {
                UIView.animate(withDuration: 0.25, delay: 0.3, animations: {
                    self.progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.4)
                }, completion: { _ in
                    self.progressView.isHidden = true
                })
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setupNavigationItem() {
        let uiBarButtonItem = UIBarButtonItem(title: "UI", style: .done, target: self, action: #selector(goUIWebViewController))
        let wkBarButtonItem = UIBarButtonItem(title: "WK", style: .done, target: self, action: #selector(goWKWebViewController))
        navigationItem.setRightBarButtonItems([uiBarButtonItem, wkBarButtonItem], animated: true)
    }
    
    @objc func goWKWebViewController() {
        let wkViewController = KSWKWebViewController()
        navigationController?.pushViewController(wkViewController, animated: true)
    }
    
    @objc func goUIWebViewController() {
        let webViewController = KSUIWebViewController()
        navigationController?.pushViewController(webViewController, animated: true)
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
        let urlString = "http://www.baidu.com/"
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
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        print("decidePolicyFor navigationResponse")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.4)
        progressView.isHidden = false
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
        progressView.isHidden = true
        print("didFinish navigation")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        print("didFail navigation")
    }
}

