//
//  TableViewController_CollectionView.swift
//  PADemo
//
//  Created by shuo on 2017/7/24.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class TableViewController_CollectionView: BaseViewController {
    
    var tableViewDelegate: PATableDelegater = PATableDelegater()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadData()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor.green
        view.addSubview(tableView)
        tableView.dataSource = tableViewDelegate
        tableView.delegate = tableViewDelegate
        tableView.tableFooterView = UIView()
        tableView.mas_makeConstraints { make in
            make!.edges.equalTo()
        }
    }
    
    func loadData() {
        var cellModel = PACellModel(classType: CollectionTableViewCell.self)
        cellModel.isEnforceFrameLayout = true
        let sectionModel = PATableViewModel.getSectionModel(cellModelTupleArr: (cellModel, 1))
        tableViewDelegate.sectionModels = [sectionModel]
        tableView.reloadData()
    }

}
