//
//  WebTableViewCell.swift
//  PADemo
//
//  Created by shuo on 2017/12/4.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class WebTableViewCell: UITableViewCell {

    let webView = UIWebView(frame: CGRect(x: 10, y: 10, width: UIScreen.width - 20, height: 10))
    let customDelegate = PAHeighWebViewDelegate()

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(webView)
        webView.delegate = customDelegate
    }
    
    func loadHTMLString(_ string: String, finish: @escaping (CGFloat) -> Void) {
        let imageMaxWidth = UIScreen.width - 20
        let style = "<style>body{font-size:14px;color: #646464}p{margin:10px}img{max-width:\(imageMaxWidth);height:auto}</style>"
        let htmStr = string.appending(style)
        webView.loadHTMLString(htmStr, baseURL: nil)
        customDelegate.finishClosure = { [weak self] height in
            self?.webView.frame.size.height = height
            finish(height)
        }
    }
    
}

class PAHeighWebViewDelegate: NSObject, UIWebViewDelegate {
    
    var finishClosure:((CGFloat)->Void)?
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let height = webView.scrollView.contentSize.height
        print("height = \(height)")
        finishClosure?(height)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let height = webView.scrollView.contentSize.height
        finishClosure?(height)
    }
}
