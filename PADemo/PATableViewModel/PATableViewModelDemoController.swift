//
//  PATableViewModelDemoController.swift
//  PADemo
//
//  Created by shuo on 2017/6/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import Masonry

class PATableViewModelDemoController: BaseViewController {

    let tableView = UITableView()
    let tableViewDelegate = PATableViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupTableView()
        updateTableView()
    }
    
    var dataSource: [String] = []
    
    func updateTableView() {
        
        tableViewDelegate.sectionModels = setupSectionModels()
        tableView.reloadData()
    }
    
    func setupSectionModels() -> [PASectionModel] {
        
        var cellModels: [PACellModel] = []
        dataSource.forEach { title in
            var cellModel = PATableViewModelDemoCell.cellModel
            cellModel.dataModel = title
            cellModels.append(cellModel)
        }
        return [PATableViewModel.getSectionModel(cellModels)]
    }
    
    func setupTableView() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()
        }
    }
    
    func setupData() {
        var text = "唧唧复唧唧！"
        for _ in 0..<10 {
            text += text
            dataSource.append(text)
        }
    }

    
}
