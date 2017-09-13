//
//  TableViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/11.
//  Copyright © 2017年 shuo. All rights reserved.
//  tableView 代理函数的执行顺序、tableView.reloadData()后cellForRaw的执行时机
//  tableViewCell 选中状态时子视图透明的解决

import UIKit
import HexColors

class TableViewController: BaseViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorColor = UIColor(hexString: "#DFDFDF")
        tableView.separatorColor = UIColor.red
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    var number: Int = 2
    var dataSource: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 44.0
        setupRightBuaButtonItem()
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsetsMake(UIScreen.navigationHeight, 0, 0, 0))
        }
        
        setupTablefooterView()
    }
    
    func setupTablefooterView() {
        /*
         iOS 10之后：可以直接调用 tableView.tableFooterView?.frame.size.height = 500 来在任何地方修改footerView的高度，并且没有显示问题；
         iOS 10之前：设置自定义footerView高度 并将其设置为tableView.tableFooterView后，高度不能直接更改
         */
        if #available(iOS 10.0, *) {
            tableView.tableFooterView = UIView()
            tableView.tableFooterView?.backgroundColor = UIColor.green
            tableView.tableFooterView?.frame.size.height = 500
        } else {
            let footerView = UIView()
            footerView.frame.size.height = 500
            footerView.backgroundColor = UIColor.green
            // 在设置tableFooterView之后不能再修改其高度，否则会出现高度改变了，但tableView的contenSize没有改变，表现为footerView显示不完全的 或过多显示
            tableView.tableFooterView = footerView
        }
        
        
    }
    
    func setupRightBuaButtonItem() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(refresh_3))
        navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    // tableView.reloadData()后 cellForRaw的执行时机
    func refresh_1() {
        debugLog("begin reloadData")
        tableView.reloadData()
        debugLog("end reloadData")
//        for i in 0...1000000 {
//            debugPrint("\(i)")
//        }
    }
    
    // tableView.reloadRows(at: [IndexPath], with: UITableViewRowAnimation)后，cellForRaw的执行时机
    func refresh_2() {
        debugLog("begin reloadData")
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        debugLog("end reloadData")
    }

    
    // 先执行 reloadData 再执行 reloadRow
    func refresh_3() {
        refresh_1()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.refresh_2()
        }
    }
    
    // 先执行 reloadRow 再执行 reloadData
    func refresh_4() {
        refresh_2()
        refresh_1()
    }
    
}

extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        debugLog()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugLog()
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugLog()
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "第\(dataSource[indexPath.row])行"
        return cell!
    }
    
    
}

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        debugLog()
        return 44.0
    }
    
    
}
