//
//  PAListViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/31.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PAListViewController: BaseTableViewController {

    var tableDelegater = PATableDelegater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
