//
//  CoreAnimationViewController.swift
//  PADemo
//
//  Created by shuo on 2018/5/4.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class CoreAnimationViewController: BaseViewController {
    
    let tableView = UITableView()
    lazy var tableDelegater: PATableViewModelDemoControllerDelegater = {
        let delegater = PATableViewModelDemoControllerDelegater()
        delegater.viewController = self
        return delegater
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let cellModel = PACellModel(classType: FPSTableViewCell.self, height: 80)
        let cellModels = [PACellModel](repeating: cellModel, count: 500)
        let sectionModel = PASectionModel(cellModelArr: cellModels)
        tableDelegater.sectionModels = [sectionModel]
    }

    func setupTableView() {
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.paBackground
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsetsMake(UIScreen.navigationHeight, 0, 0, 0))
        }
    }
    
}
