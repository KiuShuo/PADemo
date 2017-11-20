//
//  PACycleViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/22.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PACycleViewController: BaseViewController {

    fileprivate var cycleContainewView = PACycleContainerView()
    fileprivate var segmentControl: PASegmentControl!
    fileprivate var currentSegmentSelectIndex: Int = 0
    private var tableControllers: [PAListViewController] = []
    var segmentTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        segmentTitles = ["赚积分", "积分兑换"]
        setupCycleView()
        setupSegmentControl()
        
        showList(index: 0)
    }
    
    private func setupSegmentControl() {
        segmentControl = PASegmentControl.baseSegmentControl(frame: CGRect(x: 0, y: UIScreen.navigationHeight, width: UIScreen.width, height: 40), titles: segmentTitles)
        segmentControl.setSelectedSegmentIndex(0, animated: false)
        view.addSubview(segmentControl)
        segmentControl.addBottomLineView()
        segmentControl.indexChangedHandler = { [weak self] index in
            guard let `self` = self else { return }
            var animate: Bool = false
            if abs(self.currentSegmentSelectIndex - index) == 1 {
                animate = true
            }
            let offSetX = CGFloat(index) * UIScreen.width
            self.cycleContainewView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: animate)
            //self.showList(index: index)
        }
    }
    
    private func setupCycleView() {
        for _ in 0..<segmentTitles.count {
            let tableControl = PAListViewController()
            tableControllers.append(tableControl)
        }
        cycleContainewView.showsHorizontalScrollIndicator = false
        cycleContainewView.showsVerticalScrollIndicator = false
        cycleContainewView.isPagingEnabled = true
        cycleContainewView.delegate = self
        view.addSubview(cycleContainewView)
        cycleContainewView.mas_makeConstraints { make in
            make!.top.equalTo()(40 + UIScreen.navigationHeight)
            make!.left.right().bottom()
        }
        cycleContainewView.contentSize = CGSize(width: UIScreen.width * CGFloat(segmentTitles.count), height: UIScreen.height - UIScreen.navigationHeight - 40)
    }
    
    func showList(index: Int) {
        print("currentIndex = \(index)")
        let tableController = tableControllers[index]
        cycleContainewView.show(showView: tableController.view, showViewIndex: index)
    }
    
}

extension PACycleViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        segmentControl.setSelectedSegmentIndex(index, animated: true)
        currentSegmentSelectIndex = index
        showList(index: index)
    }
    
}