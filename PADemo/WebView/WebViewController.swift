//
//  WebViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/16.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        urlEncode()
    }
    
    // url编码
    func urlEncode() {
        let urlString = "https://www.baidu.com/s?wd=百度"
        if let encodeUrlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            debugLog("encodeUrlStr = \(encodeUrlStr)")
            if let decodeUrlString = encodeUrlStr.removingPercentEncoding {
                debugLog("decodeUrlString = \(decodeUrlString)")
            }
        }
    }

}
