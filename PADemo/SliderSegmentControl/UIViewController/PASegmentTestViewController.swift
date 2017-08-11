//
//  PASegmentTestViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/11.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PASegmentTestViewController: BaseViewController {

    fileprivate var tableViews: [PAIntegrationSituationTableView] = []
    private var segmentedView = PASegmentedView()
    fileprivate var topSituationView: PAIntegrationSituationTopView = {
        let topSituationView = PAIntegrationSituationTopView.instanceFromXib()
        return topSituationView
    }()
    fileprivate var segmentControl: PASegmentControl = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 40)
        let segmentControl = PASegmentControl.baseSegmentControl(frame: frame, titles: ["积分获得", "积分转换"])
        return segmentControl
    }()
    fileprivate var lastSelectedIndex: Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        let leftTableView = PAIntegrationSituationTableView()
        let rightTableView = PAIntegrationSituationTableView()
        leftTableView.configure()
        rightTableView.configure()
        tableViews = [leftTableView, rightTableView]
        
        view.addSubview(segmentedView)
        segmentedView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(self.view)!.insets()(UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0))
        }
        segmentedView.delegate = self
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
        segmentControl.applyStyle()
        segmentControl.separateStyle = .bottom
        return segmentControl
    }
    
    func segmentedViewHeaderView(in segmentedView: PASegmentedView) -> UIView {
        return topSituationView
    }
    
    func segmentedViewHeaderMaxHeight(in segmentedView: PASegmentedView) -> CGFloat {
        return 146
    }
    
    func segmentedViewHeaderMinHeight(in segmentedView: PASegmentedView) -> CGFloat {
        return 0
    }
    
    func segmentedView(_ view: PASegmentedView, didShow index: Int) {
        let view = self.tableViews[index]
        if let lastTableView = tableViews[lastSelectedIndex, defaultValue: nil] {
            self.view.removeGestureRecognizer(lastTableView.panGestureRecognizer)
        }
        lastSelectedIndex = index
        self.view.addGestureRecognizer(view.panGestureRecognizer)
    }
}
