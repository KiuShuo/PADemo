//
//  TableViewController_CellHeight.swift
//  PADemo
//
//  Created by shuo on 2017/5/19.
//  Copyright © 2017年 shuo. All rights reserved.

//  tableViewCell 创建次数
/*
 对于只有一种cell的tableView的简单模型来说：
 根据tableView的重用机制可以知道需要创建的cell个数 = 界面上同时能显示下的最多的cell个数
 如果需要一个准确的计算公式的话，可以表示为:
 let count = ceil(tableView.height / allCell.height)
 
 
 另外，自定义的cell需要注册后才能使用，每注册一次就会重新创建一个cell，而注册的时候会给该cell一个重用标示符，然后根据重用标示符来获取cell.
 
 */


import UIKit

class TableViewController_CellHeight: BaseViewController {
    
    lazy var tableView: UITableView = {
        //let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        let tableView = UITableView()
        tableView.separatorColor = UIColor.red
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height: CGFloat = 35.5
        tableView.rowHeight = height
        // ceil(tableView的高度 / cell的高度)
        let count = ceil(PADeviceSize.screenHeight / height)
        debugLog("需要创建的cell个数 = \(count)")
        
        view.addSubview(tableView)
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()
        }
    }
    
    let customTableViewCellIdentifier = String(describing: CustomTableViewCell.self)
    
    func registCell() -> UITableViewCell? {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: customTableViewCellIdentifier)
        var cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier)
        // 获取资源文件路径：
        /*
            func path(forResource name: String?, ofType ext: String?) -> String?
            只能获取到nib、plist等resource资源文件的路径 无法获取.swift .xib等文件的路径
            Products/PADemo.app文件对应的包内容中的文件，都可以看做是资源文件
         */
        if let _ = Bundle.main.path(forResource: "\(customTableViewCellIdentifier)", ofType: "nib") {
            cell = nil
            let nib = UINib(nibName: customTableViewCellIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: customTableViewCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier)
        }
        return cell
    }
    
}


extension TableViewController_CellHeight: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier)
        if cell == nil {
            cell = registCell()
        }
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }
    
}
