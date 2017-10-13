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
        let delegater = PATableViewModelDemoControllerDelegater()
        delegater.viewController = self
        return delegater
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.rowHeight = 188
        setupTableView()
        updateTableView()
        //tableView.sectionHeaderHeight = 100
        tableView.sectionFooterHeight = 100
        // testContentInsetAndContentOffset()
    }
    
    func testContentInsetAndContentOffset() {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.green
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 100)
        tableView.tableHeaderView = headerView
        
        // 当设置过contenInset.top = 100后，并不会立马显示出距离顶部100的效果，需要手动拉出来
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        // 当然，也可以设置偏移量为-100，来使tableView已经向下偏移100
        tableView.contentOffset = CGPoint(x: 0, y: -100)
        
        // 设置滑动指示器的contentInset
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        if let gestureRecognizers = tableView.gestureRecognizers {
            print("gestureRecognizers.count = \(gestureRecognizers.count)")
            for gesture in gestureRecognizers {
                print("gesture = \(gesture)")
            }
        }
    }
    
    func updateTableView() {
        tableDelegater.sectionModels = setupSectionModels()
        tableView.reloadData()
    }
    
    func setupSectionModels() -> [PASectionModel] {
        let dataSource = listTestModel.personList()
        var sectionModel = PASectionModel(cellModel: PATableViewModelDemoCell.cellModel, dataModels: dataSource)
        var headerViewModel = PAHeaderFooterViewModel(identifier: "headerView")
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "headerView")
        headerView.contentView.backgroundColor = UIColor.red
        headerViewModel.headerFooterView = headerView
        sectionModel.footerViewModel = headerViewModel
        return [sectionModel]
    }
    
    func setupTableView() {
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsetsMake(UIScreen.navigationHeight, 0, 0, 0))
        }
    }
    
}

class PATableViewModelDemoControllerDelegater: PATableDelegater {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personListVC = PAPersonListViewController()
        viewController?.navigationController?.pushViewController(personListVC, animated: true)
    }
    
}
