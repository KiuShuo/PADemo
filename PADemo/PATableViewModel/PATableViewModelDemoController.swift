//
//  PATableViewModelDemoController.swift
//  PADemo
//
//  Created by shuo on 2017/6/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

/*
 // tableView只更新cell高度不更新cell：
// 直接写下面的代码，不要再在中间添加添加什么reloadRow...
 tableView.beginUpdates()
 tableView.endUpdates()
 
 */

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
    
    let navigationView = PACustomNavigationView.instanceFromXib()
    func setupNavigationView() {
        navigationView.backgroundColor = UIColor.white
        navigationView.backButton.tintColor = UIColor.black
        view.addSubview(navigationView)
        navigationView.mas_makeConstraints { (make) in
            make!.left.top().right().equalTo()
            make!.height.equalTo()(UIScreen.navigationHeight)
        }
        navigationView.tapBackButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    var rows: [Int] = []
    var inputText: [Int: String] = [:]
    
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
    
    var persons: [PAPerson] = []
    
    func setupSectionModels() -> [PASectionModel] {
        let dataSource = listTestModel.personList()
        persons = dataSource
        var cellModel = PATableViewModelDemoCell.cellModel
        cellModel.isEnforceFrameLayout = true
        cellModel.isCacheCellHeight = false
        let sectionModel = PASectionModel(cellModel: cellModel, dataModels: dataSource)
//        var headerViewModel = PAHeaderFooterViewModel(identifier: "headerView")
//        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "headerView")
//        headerView.contentView.backgroundColor = UIColor.red
//        headerViewModel.headerFooterView = headerView
//        sectionModel.footerViewModel = headerViewModel
        return [sectionModel]
    }
    
    func setupTableView() {
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.paBackground
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsets(top: UIScreen.navigationHeight, left: 0, bottom: 0, right: 0))
        }
        tableView.estimatedRowHeight = 10
        
        tableDelegater.configureCell = { [weak self] param in
            if var aCell = param.cell as? PATableViewCellProtocol {
                aCell.dataModel = param.cellModel.dataModel
            }
            self?.configure(cell: (param.cell as! PATableViewModelDemoCell), indexPath: param.indexPath)
        }
    }
    
    func configure(cell: PATableViewModelDemoCell, indexPath: IndexPath) {
        cell.changeHeight = { [weak self] text in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
    }
    
}

class PATableViewModelDemoControllerDelegater: PATableDelegater {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personListVC = PAPersonListViewController()
        viewController?.navigationController?.pushViewController(personListVC, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cellModel = self.cellModel(indexPath)
//        tableView.registCell(withCellModels: [cellModel])
//        if cellModel.identifier == String(describing: PATableViewModelDemoCell.self) {
//            let height = tableView.fd_heightForCell(withIdentifier: cellModel.identifier, configuration: { cell in
//                (cell as? UITableViewCell)?.bounds.size.width = tableView.bounds.width
//                (cell as? UITableViewCell)?.fd_enforceFrameLayout = cellModel.isEnforceFrameLayout
//                if var aCell = cell as? PATableViewCellProtocol {
//                    aCell.dataModel = cellModel.dataModel
//                }
//            })
//            return height
//        }
//        return super.tableView(tableView, heightForRowAt: indexPath)
//    }
    
}
