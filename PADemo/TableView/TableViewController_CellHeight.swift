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
import Masonry
import MJRefresh

class TableViewController_CellHeight: BaseViewController {
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "铂金背景"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 151)
        return imageView
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 151)
        headerView.addSubview(self.headerImageView)
        headerView.addSubview(self.activityView)
        return headerView
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(frame: CGRect(x: UIScreen.width / 2 - 15, y: 30, width: 30, height: 30))
        activityView.isHidden = true
        return activityView
    }()
    
    lazy var tableView: UITableView = {
        //let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        let tableView = UITableView()
        tableView.separatorColor = UIColor.red
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = self.headerView
        return tableView
    }()
    let blackView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    func setupRefresh() {
        tableView.mj_header = MJRefreshHeader(refreshingBlock: {
            self.activityView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.activityView.stopAnimating()
                self.tableView.mj_header.endRefreshing()
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupRefresh()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        (tableView as UIScrollView).delegate = self
        
        setupData()
//        tableView.estimatedRowHeight = 20
        view.addSubview(tableView)
        extendedLayoutIncludesOpaqueBars = true
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        paNavigationBarHidden = true
        setupNavigationView()
        
//        let window = UIApplication.shared.keyWindow
//        let guideView = PAIntegrationGuideView.instanceFromXib()
//        guideView.frame = window!.frame
//        guideView.didmiss = {
//            guideView.removeFromSuperview()
//        }
//        window!.addSubview(guideView)
    }
    
    let navigationView = PACustomNavigationView.instanceFromXib()
    func setupNavigationView() {
        navigationView.backgroundColor = UIColor(R: 255, G: 255, B: 255, A: 0)
        navigationView.backButton.tintColor = UIColor.white
        view.addSubview(navigationView)
        navigationView.mas_makeConstraints { (make) in
            make!.left.top().right().equalTo()
            make!.height.equalTo()(UIScreen.navigationHeight)
        }
        navigationView.tapBackButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    var dataSource: [String] = []
    
    func setupData() {
        var text = "唧唧复唧唧，木兰当户织，不闻机杼声，但闻女叹息，问女何所思，问女何所忆！"
        for i in 0..<3 {
            text += text
            text += "--\(i)"
            dataSource.append(text)
        }
    }
    
    let customTableViewCellIdentifier = String(describing: CustomTableViewCell.self)
    
    func registCell() -> UITableViewCell? {
//        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: customTableViewCellIdentifier)
        var cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier)
        // 获取资源文件路径：
        /*
            func path(forResource name: String?, ofType ext: String?) -> String?
            只能获取到nib、plist等resource资源文件的路径 无法获取.swift .xib等文件的路径
            Products/PADemo.app文件对应的包内容中的文件，都可以看做是资源文件
         */
        if cell != nil {
            return cell
        }
        if let _ = Bundle.main.path(forResource: "\(customTableViewCellIdentifier)", ofType: "nib") {
            cell = nil
            let nib = UINib(nibName: customTableViewCellIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: customTableViewCellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: customTableViewCellIdentifier)
        }
        return cell
    }
    
}

extension TableViewController_CellHeight: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance = scrollView.contentOffset.y// + scrollView.contentInset.top
        print("distance = \(distance)")
        print("scrollView.contentInset.top = \(scrollView.contentInset.top)")
        // 导航的透明度控制
        var alpha = Float(distance / 151)
        alpha = alpha < 0 ? 0 : alpha
        alpha = alpha > 1 ? 1 : alpha
        navigationView.backgroundColor = UIColor(R: 255, G: 255, B: 255, A: alpha)
        if alpha > 0.5 {
            navigationView.backButton.tintColor = UIColor.black
        } else {
            navigationView.backButton.tintColor = UIColor.white
        }
        if distance < 0 {
            activityView.isHidden = false
            headerImageView.frame.size.height = 151 - distance
            headerImageView.frame.origin.y = distance
        } else {
            activityView.isHidden = true
        }
        
    }
    
}


extension TableViewController_CellHeight: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = registCell() as? CustomTableViewCell
        cell?.titleLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    
}

extension TableViewController_CellHeight: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let cell = registCell() as? CustomTableViewCell {
//            cell.titleLabel?.text = dataSource[indexPath.row]
//            var con: MASConstraint?
//            cell.contentView.mas_makeConstraints({ (make) in
//               con = make!.width.equalTo()(UIScreen.main.bounds.size.width)
//            })
//            let height = cell.contentView.systemLayoutSizeFitting(CGSize(width: 0, height: 10000000)).height + 1 / UIScreen.main.scale
//            con?.uninstall()
//            return height
//        }
        let height = dataSource[indexPath.row].height(width: UIScreen.main.bounds.size.width - 20, font: UIFont.systemFont(ofSize: 17)) + 20
        return height
//        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PATableViewModelDemoController()
        vc.view.backgroundColor = UIColor.white
        navigationController?.pushViewController(vc, animated: true)
//
//        guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell else { return }
//        guard let window = UIApplication.shared.keyWindow else { return }
//        let point = window.convert(cell.rightView.center, from: cell.contentView)
//
//        blackView.backgroundColor = UIColor.black
//        blackView.center = point
//        let coverView = UIView(frame: window.frame)
//        coverView.backgroundColor = UIColor.black
//        coverView.alpha = 0.3
//        window.addSubview(coverView)
//        blackView.removeFromSuperview()
//        window.addSubview(blackView)
    }
    
}
