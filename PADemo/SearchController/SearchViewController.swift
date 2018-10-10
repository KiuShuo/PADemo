//
//  SearchViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import IQKeyboardManager

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
    
    fileprivate var dataSource: [String] = ["1", "2", "3", "4", "5", "6"]
    fileprivate var searchResults: [String] = ["2", "4", "5"]

    /// 不要使用UITableViewController，有位置错位问题
    fileprivate lazy var searchResultController: SearchResultViewController_1 = {
        let searchResultController = SearchResultViewController_1()
        return searchResultController
    }()
    
    // 方式1: 当结果页和列表页相似时，使用UISearchController(searchResultsController: nil) 不设置resultsViewController，这样就会共用列表页的tableView，通过searchController.isActive 以及searchController.searchBar来判断tableView上显示的数据源；
    // 方式2: UISearchController(searchResultsController: searchResultController)，用另外一个新的viewController来展示搜索结果，这时候需要根据searchBar _UISearchBarContainerView类型的父视图来调整tableView在其父视图上的位置
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self
        // 当点击搜索框后仍显示当前界面时，通过该变量控制是否显示灰色蒙层
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.frame.size.height = 48
        searchController.delegate = self
        return searchController
    }()
    // iOS11之前 点击搜索框后 开始搜索之前 是否需要显示当前界面
    let needShowCurrentViewWhenClickSearchBarBeforeiOS11: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        setupTableView()
        setupSearchBar()
        IQKeyboardManager.shared().isEnabled = false
        
        
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
    
    
//    override func didMove(toParentViewController parent: UIViewController?) {
//        if parent == nil {
//            IQKeyboardManager.shared().isEnabled = true
//        }
//    }
    
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
                    make!.edges.equalTo()(UIEdgeInsets(top: UIScreen.navigationHeight, left: 0, bottom: 0, right: 0))
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
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return false
        //return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        print("searchtext = \(searchText)")
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchResults.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        if isFiltering() {
            cell?.textLabel?.text = "搜索结果 第\(searchResults[indexPath.row])行"
        } else {
            cell?.textLabel?.text = "第\(dataSource[indexPath.row])行"
        }
        return cell!
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
//        let offSetY = searchResultController.tableView.contentOffset.y
//        let contentInsetTop = searchResultController.tableView.contentInset.top
//        print("offSetY = \(offSetY), contentInsetTop = \(contentInsetTop)")
        filterContentForSearchText(searchController.searchBar.text!)
        if !needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
            searchResultController.tableView.isHidden = false
        }
    }
    
}

// 通过在 updateSearchResults(for searchController:) 直接让结果页面的view.isHidden = false 或这下面的调整当前界面的view.isHidden来控制点击搜索框后是否立即显示搜索结果页面

extension SearchViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        if !needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
            tableView.isHidden = true
        }
        if let superView = searchController.searchBar.superview {
            print("superView = \(superView)")
            print("superView.frame = \(superView.frame)")
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        // 当searchController完全显示出来后，会将semrchBar放到_UISearchBarContainerView类型的视图上，_UISearchBarContainerView -> _UISearchControllerView -> UITransitionView，UITransitionView与SearchViewController.view是兄弟视图
        if let superView = searchController.searchBar.superview {
            print("superView = \(superView)")
            print("superView.frame = \(superView.frame)")
        }
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        if !needShowCurrentViewWhenClickSearchBarBeforeiOS11 {
            tableView.isHidden = false
        }
    }

}

