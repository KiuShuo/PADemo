//
//  PAIntegrationSituationTableViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/10.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PAIntegrationSituationTableView: UITableView {
    
    private let tableDelegater = PATableDelegater()
    private weak var controller: UIViewController!
    var isFirstLoad: Bool = true
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    func configure() {
        delegate = tableDelegater
        dataSource = tableDelegater
        tableDelegater.viewController = viewController
        
        let cellModel = PACellModel(identifier: String(describing: PAIntegrationSituationCell.self), height: 86)
        tableDelegater.sectionModels = [PATableViewModel.getSectionModel(cellModelTupleArr: (cellModel, 20))]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    convenience init(viewController: UIViewController) {
//        self.init()
//        self.controller = viewController
//        
//        delegate = tableDelegater
//        dataSource = tableDelegater
//        tableDelegater.viewController = viewController
//        
//        let cellModel = PACellModel(identifier: String(describing: PAIntegrationSituationCell.self), height: 86)
//        tableDelegater.sectionModels = [PATableViewModel.getSectionModel(cellModelTupleArr: (cellModel, 20))]
//        
//        addObserver(controller, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
//    }
    
    deinit {
        print(String(describing: self.classForCoder) + "析构方法执行")
    }

}

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
