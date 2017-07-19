//
//  SearchViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    
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

//    fileprivate lazy var searchResultController: SearchResultViewController = {
//        let searchResultController = SearchResultViewController()
//        return searchResultController
//    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.delegate = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make!.left.right().bottom().equalTo()
            make!.top.equalTo()
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
    //
}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    
}

extension SearchViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.isHidden = false
    }
    
}
