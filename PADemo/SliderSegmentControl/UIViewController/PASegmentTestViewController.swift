//
//  PASegmentTestViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/11.
//  Copyright © 2017年 shuo. All rights reserved.
//


/**
 界面构成：
 [层级](--kiushuo/Image/带有一个header的多列表界面.png)
 
 核心点：
 

*/

import UIKit

class PASegmentTestViewController: BaseViewController {

    fileprivate var tableViews: [PAIntegrationSituationTableView] = []
    fileprivate var segmentedView = PASegmentedView()
    fileprivate var topSituationView: PAIntegrationSituationTopView = {
        let topSituationView = PAIntegrationSituationTopView.instanceFromXib()
        return topSituationView
    }()
    fileprivate var lastSelectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let leftTableView = PAIntegrationSituationTableView(viewType: .left)
        let rightTableView = PAIntegrationSituationTableView(viewType: .right)
        tableViews = [leftTableView, rightTableView]
        leftTableView.configure()
        rightTableView.configure()
        view.addSubview(segmentedView)
        segmentedView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(self.view)!.insets()(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        }
        segmentedView.delegate = self
//        segmentedView.isRefreshEnable = true
        segmentedView.headerLeaveWay = .changeOriginY
        segmentedView.isHeaderScrollEnable = true
        segmentedView.reloadData()
    }

}

extension PASegmentTestViewController: PASegmentedViewDelegate {
    
    func segmentedViewTitles(in segmentedView: PASegmentedView) -> [String] {
        return ["积分获得", "积分转换"]
    }
    
    func segmentedView(_ view: PASegmentedView, viewForIndex index: Int) -> UIView {
        return self.tableViews[index]
    }
    
    func segmentedViewSegmentedControlView(in segmentedView: PASegmentedView) -> UIView {
        let segmentControl = PASegmentedControlView()
        segmentControl.separateStyle = .topAndBottom
        segmentControl.selectionIndicatorPosition = .bottom
        return segmentControl
    }
    
    func segmentedViewHeaderView(in segmentedView: PASegmentedView) -> UIView {
        return topSituationView
    }
    
    func segmentedViewHeaderMaxHeight(in segmentedView: PASegmentedView) -> CGFloat {
        return 180
    }
    
    func segmentedViewHeaderMinHeight(in segmentedView: PASegmentedView) -> CGFloat {
        return 0
    }
    
    func segmentedView(_ view: PASegmentedView, didShow index: Int) {
        let tableView = self.tableViews[index]
        if tableView.isFirstLoad {
            tableView.isFirstLoad = false
//            tableView.mj_header.beginRefreshing()
        }
        
        let size = CGSize(width: UIScreen.width, height: CGFloat.greatestFiniteMagnitude)
        let tableViewHeight = tableView.sizeThatFits(size).height - 146
        if tableViewHeight < UIScreen.height - UIScreen.navigationHeight {
            let footerView = UIView()
            footerView.frame.size.height = UIScreen.height - UIScreen.navigationHeight - tableViewHeight
            tableView.tableFooterView = footerView
        }
    }
}


