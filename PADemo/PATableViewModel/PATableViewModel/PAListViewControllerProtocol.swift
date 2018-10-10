//
//  PAListViewControllerProtocol.swift
//  PADemo
//
//  Created by shuo on 2017/8/22.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

/// 继承自UITableViewController 使用PATableDelegater时的公共代码
protocol PAListViewControllerProtocol where Self: BaseTableViewController {
    var tableDelegater: PATableDelegater? { set get }
}

extension PAListViewControllerProtocol {
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = tableDelegater
        tableView.delegate = tableDelegater
        tableDelegater?.viewController = self
        tableDelegater?.tableView = tableView
    }
    
    func reloadData(_ sectionModels: [PASectionModel]) {
        tableDelegater?.sectionModels = sectionModels
        tableView.reloadData()
    }
    
}

/// 继承自UIViewController上面放UITableView 使用PATableDelegater时的公共代码
protocol PAListCombineViewControllerProtocol where Self: BaseViewController {
    var tableView: UITableView { set get }
    var tableDelegater: PATableDelegater? { set get }
}

extension PAListCombineViewControllerProtocol {
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.paBackground
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        view.addSubview(tableView)
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsets(top: UIScreen.navigationHeight, left: 0, bottom: 0, right: 0))
        }
        tableDelegater?.viewController = self
        tableDelegater?.tableView = tableView
    }
    
    func reloadData(_ sectionModels: [PASectionModel]) {
        tableDelegater?.sectionModels = sectionModels
        tableView.reloadData()
    }
    
}
