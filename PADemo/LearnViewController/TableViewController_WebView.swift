//
//  TableViewController_WebView.swift
//  PADemo
//
//  Created by shuo on 2017/12/4.
//  Copyright © 2017年 shuo. All rights reserved.
//  cell上展示webView

import UIKit

class TableViewController_WebView: UITableViewController {
    
    // 用以计算web高度
    fileprivate var menuTableViewDelegate = PATableDelegater()
//    fileprivate let heightWeb = PAHeighWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.width - 20, height: 10))
    fileprivate let heightSem = DispatchSemaphore(value: 0)
    fileprivate let heightQueue = DispatchQueue(label: "Web height queue")
    fileprivate var heightCache: CGFloat = 0
//    let htmStr: String = "\"<ol class=\" list-paddingleft-2\" style=\"list-style-type: decimal;\"><li><p>普通商品1。</p></li><li><p>普通商品2。</p></li><li><p>普通商品3。</p></li><li><p>普通商品4。</p></li><li><p>普通商品5。</p></li><li><p>普通商品6。</p></li><li><p>普通商品7。</p></li><li><p>普通商品8。</p></li><li><p>普通商品9。</p></li></ol>\""
    let htmStr: String = "\"<ol class=\" list-paddingleft-2\" style=\"list-style-type: decimal;\"><li><p>普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品普通商品1。</p></li><li><p>普通商品2。</p></li><li><p>普通商品3。</p></li><li><p>普通商品4。</p></li><li><p>普通商品5。</p></li><li><p>普通商品6。</p></li><li><p>普通商品7。</p></li><li><p>普通商品8。</p></li><li><p>普通商品9。</p></li></ol><p><img src=\"https://imagedev.pawjzs.com/ueditor/jsp/upload/image/20171204/1512368322590067511.jpg\" title=\"\" alt=\"image003.jpg\"/></p>\""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: String(describing: WebTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: WebTableViewCell.self))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WebTableViewCell.self), for: indexPath) as! WebTableViewCell
        
        cell.loadHTMLString(self.htmStr) { height in
            self.heightCache = height + 20
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCache
    }
}

