//
//  PAListViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/31.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

// UITableViewController
class PAListViewController: BaseTableViewController {

    var tableDelegater = PATableDelegater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        print("self = \(self)")
        if let delegate = (tableView as UIScrollView).delegate {
            print("delegate = \(delegate)")
        }
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
    }
    
    func reloadData(_ sectionModels: [PASectionModel]) {
        tableDelegater.sectionModels = sectionModels
        tableView.reloadData()
    }

}

// UIViewController + UITableView
class PAListCombineViewController: BaseViewController {
    
    var tableView: UITableView!
    var tableDelegater: PATableDelegater!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView(tableViewStyle: UITableViewStyle = .plain, tableDelegater: PATableDelegater = PATableDelegater()) {
        self.tableView = {
            tableView = UITableView(frame: .zero, style: tableViewStyle)
            tableView.separatorStyle = .none
            tableView.delegate = tableDelegater
            tableView.dataSource = tableDelegater
            tableView.backgroundColor = UIColor.paBackground
            return tableView
        }()
        view.addSubview(tableView)
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsetsMake(UIScreen.navigationHeight, 0, 0, 0))
        }
        tableDelegater.tableView = tableView
        self.tableDelegater = tableDelegater
    }
    
    func reloadData(_ sectionModels: [PASectionModel]) {
        tableDelegater.sectionModels = sectionModels
        tableView.reloadData()
    }
    
}
