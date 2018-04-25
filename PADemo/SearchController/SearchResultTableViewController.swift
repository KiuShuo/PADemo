//
//  SearchResultTableViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

/// 使用UITableViewController一直有显示问题，所以在问题没解决之前不使用

import UIKit

class SearchResultTableViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 即使加上这行代码也有问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "resultCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "resultCell")
        }
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }

}
