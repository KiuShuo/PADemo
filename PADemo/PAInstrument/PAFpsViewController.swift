//
//  PAFpsViewController.swift
//  PADemo
//
//  Created by shuo on 2017/7/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PAFpsViewController: BaseViewController {
    
    fileprivate let tableViewDelegate = PATableDelegater()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit性能测试"
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make!.edges.equalTo()(UIEdgeInsetsMake(UIScreen.navigationHeight, 0, 0, 0))
        }
        
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        
        var cellModel1 = PACellModel(classType: PAFpsTableViewCell.self)
        var cellModel2 = PACellModel(classType: PAFpsViewTableViewCell.self)
        cellModel1.height = 80
        cellModel2.height = 80
        let sectionModel = PASectionModel(cellModelArr: [cellModel1, cellModel2])
        tableViewDelegate.sectionModels = [PASectionModel](repeatElement(sectionModel, count: 100))
        tableView.reloadData()
        
        tableViewDelegate.configureCell = { params in
            switch params.cellModel.identifier {
            case String(describing: PAFpsTableViewCell.self):
                let fpsCell = params.cell as! PAFpsTableViewCell
                fpsCell.configureImageView()
            case String(describing: PAFpsViewTableViewCell.self):
                let fpsCell = params.cell as! PAFpsViewTableViewCell
                fpsCell.setCornerRadius()
            default: ()
            }
        }
        
        tableViewDelegate.didSelectCell = { [weak self] params in
            let rectInTableView = params.tableView.rectForRow(at: params.indexPath)
            let rectInView = params.tableView.convert(rectInTableView, to: self?.view)
            let showPoint = CGPoint(x: rectInView.origin.x + 32, y: rectInView.origin.y + 40)
            self?.showMenuVC(point: showPoint)
        }
        
    }
    
    func showMenuVC(point: CGPoint) {
        let vc = MenuViewController(origin: point)
        vc.dataSource = ["西医", "中医", "口腔"]
        addChildViewController(vc)
        view.addSubview(vc.view)
    }

}
