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

    let listTestModel = PAListTestModel()
    let tableView = UITableView()
    lazy var tableDelegater: PATableViewModelDemoControllerDelegater = {
        return PATableViewModelDemoControllerDelegater(viewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        updateTableView()
    }
    
    func updateTableView() {
        tableDelegater.sectionModels = setupSectionModels()
        tableView.reloadData()
    }
    
    func setupSectionModels() -> [PASectionModel] {
        var cellModels: [PACellModel] = []
        let dataSource = listTestModel.personList()
        dataSource.forEach { person in
            var cellModel = PATableViewModelDemoCell.cellModel
            cellModel.dataModel = person
            cellModels.append(cellModel)
        }
        return [PATableViewModel.getSectionModel(cellModels)]
    }
    
    func setupTableView() {
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()
        }
        
//        tableViewDelegate.didSelectCell = {[weak self] param in
//            guard let `self` = self else { return }
//            let personListVC = PAPersonListViewController()
//            self.navigationController?.pushViewController(personListVC, animated: true)
//        }
    }
    
}

class PATableViewModelDemoControllerDelegater: PATableDelegater {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personListVC = PAPersonListViewController()
        viewController?.navigationController?.pushViewController(personListVC, animated: true)
    }
    
}
