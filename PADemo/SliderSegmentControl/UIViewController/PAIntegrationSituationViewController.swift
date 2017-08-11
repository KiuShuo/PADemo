//
//  PAIntegrationSituationViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/10.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import Masonry

class PAIntegrationSituationViewController: BaseViewController {
    
    private var cycleContainerView = PACycleContainerView()
    fileprivate var topSituationView: PAIntegrationSituationTopView = {
        let topSituationView = PAIntegrationSituationTopView.instanceFromXib()
        return topSituationView
    }()
    
    fileprivate let topSituationViewHeight: CGFloat = 146
    fileprivate let emptyViewHeight: CGFloat = 10
    fileprivate let segmentControlHeight: CGFloat = 40
    fileprivate var tableViewContentInsetTop: CGFloat = 260

    fileprivate var segmentControl: PASegmentControl = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 40)
        let segmentControl = PASegmentControl.baseSegmentControl(frame: frame, titles: ["积分获得", "积分转换"])
        return segmentControl
    }()
    private var tableViews: [PAIntegrationSituationTableView] = []
    fileprivate var topSituationViewY: CGFloat = UIScreen.navigationHeight
    fileprivate let topSituationViewMinY: CGFloat = -96 // topSituationViewHeight + emptyViewHeight - UIScreen.navigationHeight
    fileprivate var currentSegmentIndex: Int = 0
    fileprivate var lastSegmentIndex: Int = -1
    
    fileprivate var isVerticalPan: Bool = false
    fileprivate var isChangeTable: Bool = false
    fileprivate var tableOffsetY: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
//        setupUI()
//        setupCycleContainerView()
//        setupSegmentControl()
//        
//        showTableView(index: currentSegmentIndex)
        
        creatRightItem()
    }
    
    func creatRightItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "明细", style: .plain, target: self, action: #selector(clickBusinessDetail))
    }
    
    func clickBusinessDetail() {
        navigationController?.pushViewController(PASegmentTestViewController(), animated: true)
    }
    
    private func setupUI() {
        view.addSubview(cycleContainerView)
        cycleContainerView.mas_makeConstraints { make in
            make!.edges.equalTo()
        }
        cycleContainerView.contentSize = CGSize(width: UIScreen.width * 2, height: UIScreen.height - UIScreen.navigationHeight)
        cycleContainerView.backgroundColor = UIColor.paBackground
        
        topSituationView.clipsToBounds = true
        view.addSubview(topSituationView)
        topSituationView.mas_makeConstraints { make in
            make!.top.equalTo()(UIScreen.navigationHeight)
            make!.left.right().equalTo()
            make!.height.equalTo()(self.topSituationViewHeight)
        }
        
        let emptyView = UIView()
        emptyView.backgroundColor = UIColor.paBackground
        view.addSubview(emptyView)
        emptyView.mas_makeConstraints { make in
            make!.top.equalTo()(self.topSituationView.mas_bottom)
            make!.height.equalTo()(self.emptyViewHeight)
            make!.left.right().equalTo()
        }
        
        view.addSubview(segmentControl)
        segmentControl.mas_makeConstraints { make in
            make!.top.equalTo()(emptyView.mas_bottom)
            make!.left.right().equalTo()
            make!.height.equalTo()(self.segmentControl.frame.size.height)
        }
        view.layoutIfNeeded()
        segmentControl.layer.borderWidth = UIScreen.separatorSize
        segmentControl.layer.borderColor = UIColor.paDividing.cgColor
    }
    
    private func setupCycleContainerView() {
        cycleContainerView.showsVerticalScrollIndicator = false
        cycleContainerView.showsHorizontalScrollIndicator = false
        cycleContainerView.delegate = self
        cycleContainerView.isPagingEnabled = true
        
        segmentControl.titles.forEach { _ in
//            let tableView = PAIntegrationSituationTableView(viewController: self)
//            self.tableViews.append(tableView)
        }
    }
    
    fileprivate func showTableView(index: Int) {
        isChangeTable = true
        let tableView = tableViews[index]
        if tableViews.contains(index: lastSegmentIndex) {
            let lastTableView = tableViews[lastSegmentIndex]
            view.removeGestureRecognizer(lastTableView.panGestureRecognizer)
        }
        tableViewContentInsetTop = UIScreen.navigationHeight + topSituationViewHeight + emptyViewHeight + segmentControlHeight
        view.addGestureRecognizer(tableView.panGestureRecognizer)
        tableView.isFirstLoad = false
         cycleContainerView.show(showView: tableView, showViewIndex: index)
        tableView.contentInset = UIEdgeInsets(top: tableViewContentInsetTop, left: 0, bottom: 0, right: 0)
        tableView.contentOffset.y = tableOffsetY
        isChangeTable = false
    }
    
    private func setupSegmentControl() {
        segmentControl.indexChangedHandler = {[weak self] index in
            guard let `self` = self else { return }
            let offSetX: CGFloat = CGFloat(index) * UIScreen.width
            self.cycleContainerView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != "contentOffset" {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard let scrollView = object as? UIScrollView else {
            return
        }
        if !tableViews.contains(index: currentSegmentIndex) { return }
        if tableViews[currentSegmentIndex] != scrollView {
            return
        }
        
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewOffsetY = scrollView.contentOffset.y + tableViewContentInsetTop
//        print("tableViewOffsetY = \(tableViewOffsetY)")
//        print("tableView isFirstLoad = \((scrollView as! PAIntegrationSituationTableView).isFirstLoad)")
//        if !isChangeTable {
            topSituationViewY = max(UIScreen.navigationHeight - tableViewOffsetY, topSituationViewMinY)
//        }
        print("topSituationViewY = \(topSituationViewY)")
        print("scrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        print("scrollView.contentInset.top = \(scrollView.contentInset.top)")
        topSituationView.mas_updateConstraints { make in
            make!.top.equalTo()(self.topSituationViewY)
        }
        
        
        if tableViewOffsetY >= 0 {
            for tableView in tableViews {
                tableOffsetY = min(contentOffsetY, UIScreen.navigationHeight + emptyViewHeight)
                if tableView != scrollView {
                    tableView.contentOffset.y = tableOffsetY
                }
            }
        }
        /*
        if tableViewOffsetY == 0 { // 初始状态
            for tableView in tableViews {
                if tableView != scrollView {
                    tableView.contentOffset.y = -tableViewContentInsetTop
                }
            }
        } else if tableViewOffsetY > 0 && tableViewOffsetY <= UIScreen.navigationHeight + topSituationViewHeight + emptyViewHeight { // 初始状态向上拉
            let offsetY = min(contentOffsetY, UIScreen.navigationHeight + emptyViewHeight)
            for tableView in tableViews {
                if tableView != scrollView {
                    tableView.contentOffset.y = offsetY
                }
            }
        } else if tableViewOffsetY > UIScreen.navigationHeight + topSituationViewHeight + emptyViewHeight {
            for tableView in tableViews {
                if tableView != scrollView {
                    tableView.contentOffset.y = UIScreen.navigationHeight + emptyViewHeight
                }
            }
        }*/
        
    }
    
    deinit {
        tableViews.forEach { tableView in
            tableView.removeObserver(self, forKeyPath: "contentOffset")
        }
        print(String(describing: self.classForCoder) + "析构方法执行")
    }

}

extension PAIntegrationSituationViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        lastSegmentIndex = currentSegmentIndex
        currentSegmentIndex = index
        segmentControl.setSelectedSegmentIndex(index, animated: true)
        showTableView(index: index)
    }
    
}

extension Array {
    
    func contains(index: Int) -> Bool {
        if -1 < index && index < self.count {
            return true
        }
        return false
    }
    
}
