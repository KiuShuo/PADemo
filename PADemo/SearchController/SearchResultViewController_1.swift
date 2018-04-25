//
//  SearchResultViewController_1.swift
//  PADemo
//
//  Created by shuo on 2018/4/24.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class SearchResultViewController_1: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.green
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        // 由于searchBar有一个_UISearchBarContainerView类型的父视图，所以需要调整tableView的距离顶部的位置
        if UIDevice.isIPHONE_X {
            tableView.mas_makeConstraints { (make) in
                make!.edges.equalTo()(self.view)!.insets()(UIEdgeInsets.init(top: 99,
                                                                             left: 0,
                                                                             bottom: 0,
                                                                             right: 0))
            }
        } else {
            tableView.mas_makeConstraints { (make) in
                make!.edges.equalTo()(self.view)!.insets()(UIEdgeInsets.init(top: UIScreen.navigationHeight,
                                                                             left: 0,
                                                                             bottom: 0,
                                                                             right: 0))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "resultCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "resultCell")
        }
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
