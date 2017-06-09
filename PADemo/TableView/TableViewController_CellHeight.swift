//
//  TableViewController_CellHeight.swift
//  PADemo
//
//  Created by shuo on 2017/5/19.
//  Copyright © 2017年 shuo. All rights reserved.

//  tableViewCell 创建次数
/*
 对于只有一种cell的tableView的简单模型来说：
 根据tableView的重用机制可以知道需要创建的cell个数 = 界面上同时能显示下的最多的cell个数
 如果需要一个准确的计算公式的话，可以表示为:
 let count = ceil(tableView.height / allCell.height)
 
 
 另外，自定义的cell需要注册后才能使用，每注册一次就会重新创建一个cell，而注册的时候会给该cell一个重用标示符，然后根据重用标示符来获取cell.
 
 */


import UIKit
import Masonry

class TableViewController_CellHeight: BaseViewController {
    
    lazy var tableView: UITableView = {
        //let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        let tableView = UITableView()
        tableView.separatorColor = UIColor.red
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let height: CGFloat = 35.5
//        tableView.rowHeight = height
        // ceil(tableView的高度 / cell的高度)
//        let count = ceil(PADeviceSize.screenHeight / height)
//        debugLog("需要创建的cell个数 = \(count)")
        
        setupData()
//        tableView.estimatedRowHeight = 20
        view.addSubview(tableView)
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()
        }
    }
    
    var dataSource: [String] = []
    
    func setupData() {
        var text = "唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！"
        for i in 0..<10 {
            text += text
            text += "--\(i)"
            dataSource.append(text)
        }
    }
    
    let customTableViewCellIdentifier = String(describing: CustomTableViewCell.self)
    
    func registCell() -> UITableViewCell? {
//        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: customTableViewCellIdentifier)
        var cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier)
        // 获取资源文件路径：
        /*
            func path(forResource name: String?, ofType ext: String?) -> String?
            只能获取到nib、plist等resource资源文件的路径 无法获取.swift .xib等文件的路径
            Products/PADemo.app文件对应的包内容中的文件，都可以看做是资源文件
         */
        if cell != nil {
            return cell!
        }
        if let _ = Bundle.main.path(forResource: "\(customTableViewCellIdentifier)", ofType: "nib") {
            cell = nil
            let nib = UINib(nibName: customTableViewCellIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: customTableViewCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier)
        }
        return cell
    }
    
}


extension TableViewController_CellHeight: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = registCell() as? CustomTableViewCell
        if cell == nil {
            cell = registCell() as? CustomTableViewCell
        }
        cell?.titleLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    
}

extension TableViewController_CellHeight: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let cell = registCell() as? CustomTableViewCell {
//            cell.titleLabel?.text = dataSource[indexPath.row]
//            var con: MASConstraint?
//            cell.contentView.mas_makeConstraints({ (make) in
//               con = make!.width.equalTo()(UIScreen.main.bounds.size.width)
//            })
//            let height = cell.contentView.systemLayoutSizeFitting(CGSize(width: 0, height: 10000000)).height + 1 / UIScreen.main.scale
//            con?.uninstall()
//            return height
//        }
        
        
        let height = PAStringHeightMakeWithText(dataSource[indexPath.row], 17, 0, UIScreen.main.bounds.size.width - 20) + 20
        return height
//        return 0
    }
    
}
