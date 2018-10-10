//
//  MenuViewController.swift
//  PADemo
//
//  Created by shuo on 2018/6/16.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    var sourceOrigin: CGPoint = CGPoint.zero
    var width: CGFloat = 112
    var height: CGFloat = 132
    var dataSource: [String] = []
    
    required init(origin: CGPoint) {
        super.init(nibName: nil, bundle: nil)
        self.sourceOrigin = origin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        showList()
        view.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func dismiss() {
        tableView.mas_updateConstraints { (make) in
            make!.height.equalTo()(0)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.mas_makeConstraints { (make) in
            make!.left.equalTo()(self.sourceOrigin.x)
            make!.top.equalTo()(self.sourceOrigin.y)
            make!.width.equalTo()(self.width)
            make!.height.equalTo()(0)
        }
        view.layoutIfNeeded()
    }
    
    private func showList() {
        tableView.mas_updateConstraints { (make) in
            make!.height.equalTo()(self.height)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "menuCell")
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss()
    }
    
}

