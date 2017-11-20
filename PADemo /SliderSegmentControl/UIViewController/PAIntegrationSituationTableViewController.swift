//
//  PAIntegrationSituationTableViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/10.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import MJRefresh

class PAIntegrationSituationTableView: UITableView {
    
    enum ViewType {
        case left
        case right
        case none
    }
    
    private let tableDelegater = PATableDelegater()
    var controller: UIViewController!
    var isFirstLoad: Bool = true
    
    
    var viewType: ViewType!
    
    convenience init(viewType: ViewType) {
        self.init()
        self.backgroundColor = UIColor.white
        self.viewType = viewType
    }
    
    func configure() {
        delegate = tableDelegater
        dataSource = tableDelegater
        tableDelegater.viewController = viewController
        let cellModel = PACellModel(identifier: String(describing: PAIntegrationSituationCell.self), height: 86)
        if viewType == .left {
            tableDelegater.sectionModels = [PATableViewModel.getSectionModel(cellModelTupleArr: (cellModel, 2))]
        } else {
            tableDelegater.sectionModels = [PATableViewModel.getSectionModel(cellModelTupleArr: (cellModel, 20))]
        }
        
        setupRefresh()
    }
    
    
    func setupRefresh() {
        self.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { 
                self.mj_header.endRefreshing()
            })
        })
    }
    
    deinit {
        print(String(describing: self.classForCoder) + "析构方法执行")
    }

}
/*
class PAIntegrationSituationTableViewController: BaseViewController {
    
    let tableView = UITableView()
    private let tableDelegater = PATableDelegater()
    weak var containerController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make!.edges.equalTo()
        }
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        
        let cellModel = PACellModel(identifier: String(describing: PAIntegrationSituationCell.self), height: 86)
        tableDelegater.sectionModels = [PATableViewModel.getSectionModel(cellModelTupleArr: (cellModel, 20))]
        
        if let containerController = containerController {
            tableView.addObserver(containerController, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        }
    }

}
*/
