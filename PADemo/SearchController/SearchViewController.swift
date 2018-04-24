//
//  SearchViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

// http://qmuiteam.com/ios/
// https://github.com/QMUI/QMUI_iOS
// https://github.com/boai/BAWeChat

import UIKit
import IQKeyboardManager
import QMUIKit

class SearchViewController:  BaseViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    fileprivate var dataSource: [String] = ["1", "2", "3"]

    fileprivate lazy var searchResultController: SearchResultViewController = {
        let searchResultController = SearchResultViewController()
        return searchResultController
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: self.searchResultController)
        searchController.searchResultsUpdater = self
        // 当点击搜索框后仍显示当前界面时，通过该变量控制是否显示灰色蒙层
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.frame.size.height = 48
        searchController.delegate = self
        return searchController
    }()
    // iOS11之前 点击搜索框后 开始搜索之前 是否需要显示当前界面
    let needShowCurrentViewWhenClickSearchBarBeforeiOS11: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        setupTableView()
        setupSearchBar()
        if #available(iOS 11.0, *) {
            
        } else {
            if needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
                automaticallyAdjustsScrollViewInsets = true
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
        }
        extendedLayoutIncludesOpaqueBars = true
    }
    
    /*
     当当前界面是UIViewController, iOS11之前 点击搜索框后 开始搜索之前 需要显示当前界面 点击搜索->取消搜索->table view向下移动， 解决办法关闭IQKeyboardManager；
     当当前controller是UITableViewController的时候IQKeyboardManager没有影响；
     当不需要显示当前界面的时候 不需要让tableView跟随搜索框向上移动的时候不会向下移动。
     iOS11之后也不会影响；
     
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
            IQKeyboardManager.shared().isEnabled = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
            IQKeyboardManager.shared().isEnabled = true
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            if #available(iOS 11.0, *) {
                make!.edges.equalTo()
            } else {
                if self.needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
                    make!.edges.equalTo()
                } else {
                    make!.edges.equalTo()(UIEdgeInsetsMake(UIScreen.navigationHeight, 0, 0, 0))
                }
            }
        }
    }
    
    private func setupSearchBar() {
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        definesPresentationContext = true
        searchBar.placeholder = "搜索患者姓名/手机号"
        tableView.tableHeaderView = searchBar
        tableView.subviews.first?.backgroundColor = UIColor.clear
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "第\(dataSource[indexPath.row])行"
        return cell!
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let qmui_searchVC = QMUISearchController()
//        qmui_searchVC.searchResultsDelegate = self
//        qmui_searchVC. =
//        navigationController?.pushViewController(qmui_searchVC, animated: true)
    }
    
}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        IQKeyboardManager.shared().resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let offSetY = searchResultController.tableView.contentOffset.y
        let contentInsetTop = searchResultController.tableView.contentInset.top
        print("offSetY = \(offSetY), contentInsetTop = \(contentInsetTop)")
//        if !needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
//            searchResultController.tableView.isHidden = false
//        }
    }
    
}

// 通过在 updateSearchResults(for searchController:) 直接让结果页面的view.isHidden = false 或这下面的调整当前界面的view.isHidden来控制点击搜索框后是否立即显示搜索结果页面

extension SearchViewController: UISearchControllerDelegate {

//    func willPresentSearchController(_ searchController: UISearchController) {
//        if !needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
//            tableView.isHidden = true
//        }
//    }
//
//    func willDismissSearchController(_ searchController: UISearchController) {
//        if !needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
//            tableView.isHidden = false
//        }
//    }

}

//extension SearchViewController: QMUISearchControllerDelegate {
//    func searchController(_ searchController: QMUISearchController!, updateResultsForSearch searchString: String!) {
//        //
//    }
//
//
//}

