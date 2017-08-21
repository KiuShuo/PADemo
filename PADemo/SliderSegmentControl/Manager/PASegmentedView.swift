//
//  PASegmentTableView.swift
//  wanjia2B
//
//  Created by 邵伟男 on 2017/5/8.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit
import Masonry
import MJRefresh

@objc protocol PASegmentedControlProtocol: class {
    func reloadData(with titles: [String])
    func userScrollExtent(_ extent: CGFloat)
    func setAction(_ actionBlock: ((_ index: Int) -> Void)?)
}

@objc protocol PASegmentedViewDelegate: class {
    
    func segmentedViewTitles(in segmentedView: PASegmentedView) -> [String]
    
    func segmentedView(_ view: PASegmentedView, viewForIndex index: Int) -> UIView
    
    @objc optional func segmentedView(_ view: PASegmentedView, didShow index: Int)
    
    @objc optional func segmentedViewSegmentedControlView(in segmentedView: PASegmentedView) -> UIView
    // default is 0
    @objc optional func segmentedViewFirstStartSelectIndex(in segmentedView: PASegmentedView) -> Int
    // default is nil
    @objc optional func segmentedViewHeaderView(in segmentedView: PASegmentedView) -> UIView
    // default is segmentedViewHeaderView height
    @objc optional func segmentedViewHeaderMaxHeight(in segmentedView: PASegmentedView) -> CGFloat
    // default is segmentedViewHeaderView height
    @objc optional func segmentedViewHeaderMinHeight(in segmentedView: PASegmentedView) -> CGFloat
    // when scroll top or bottom, change the titles view height , will run this method
    @objc optional func segmentedView(_ view: PASegmentedView, didChangeHeaderHeightTo height: CGFloat)
    
}

class PASegmentedView: UIView {
    enum HeaderLeaveWay {
        case changeHeight
        case changeOriginY
    }
    
    weak var delegate: PASegmentedViewDelegate?
    var headerLeaveWay: HeaderLeaveWay = .changeHeight
    var isRefreshEnable: Bool = false {
        didSet {
            if isRefreshEnable {
                headerLeaveWay = .changeOriginY
            }
        }
    }
    var isHeaderScrollEnable: Bool = false
    
    fileprivate(set) var currentIndex: Int = -1
    
    // Height
    fileprivate var headerMaxHeight: CGFloat = 300
    fileprivate var headerMinHeight: CGFloat = 100
    fileprivate var currentHeaderHeight: CGFloat = 300 {
        didSet {
            self.updateHeaderViewConstraints()
        }
    }
    
    fileprivate var pageCount: Int = 0
    
    // views
    fileprivate var scrollView: UIScrollView!
    fileprivate var backgroundView: UIView!
    fileprivate var headerView: UIView!
    fileprivate var viewArray = [UIScrollView]()
    fileprivate var segmentedControlView: UIView?
    fileprivate var segmentedControlView_P: PASegmentedControlProtocol? {
        get {
            if segmentedControlView != nil {
                assert((segmentedControlView as? PASegmentedControlProtocol) != nil, "segmentedControl must is 'nil' or a 'UIView and conforming to PASegmentedControlProtocol'")
            }
            return segmentedControlView as? PASegmentedControlProtocol
        }
    }
    
    // signal
    fileprivate var isUserScroll: Bool = false
    fileprivate var isFirstLayout: Bool = true
    fileprivate var isFirstReloadData: Bool = true
    
    deinit {
        self.removeObserver(from: viewArray[currentIndex])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        self.addSubview(backgroundView)
        backgroundView.mas_makeConstraints { (make) in
            make!.left.right().top().bottom().equalTo()(self)
        }
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        scrollView.mas_makeConstraints { (make) in
            make!.left.top().right().bottom().equalTo()(self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            self.selectDefaultIndex()
        }
    }
    
    func reloadData() {
        guard let delegate = self.delegate else {
            return
        }
        
        if !self.isFirstReloadData {
            // 不是第一次reloadData的时候需要移除之前的Observe
            self.removeObserver(from: self.viewArray[currentIndex])
        }
        
        // 清理之前存在的view
        for v in self.viewArray {
            v.removeFromSuperview()
        }
        self.viewArray.removeAll()
        
        let titles = delegate.segmentedViewTitles(in: self)
        pageCount = titles.count
        
        let headerView = delegate.segmentedViewHeaderView?(in: self)
        self.createHeader(baseHeader: headerView, titles: titles)
        
        
        for index in 0..<pageCount {
            let view = delegate.segmentedView(self, viewForIndex: index)
            self.addView(view, to: index)
        }
        
        // 不是第一次reloadData时候直接去选择index
        if !self.isFirstReloadData {
            self.selectDefaultIndex()
        }
        self.isFirstReloadData = false
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if /*self.scrollView.contentOffset.x <= 0 &&*/ point.x <= 20 {
            return self.backgroundView.hitTest(point, with: event)
        }
        return super.hitTest(point, with: event)
    }
    
    fileprivate func updateHeaderViewConstraints() {
        if self.headerView == nil {
            return
        }
        if !isRefreshEnable {
            if headerLeaveWay == .changeOriginY && self.currentHeaderHeight < self.headerMaxHeight {
                self.headerView.mas_updateConstraints { make in
                    make!.top.equalTo()(self.currentHeaderHeight - self.headerMaxHeight)
                    make!.height.equalTo()(self.headerMaxHeight)
                }
            } else {
                self.headerView.mas_updateConstraints { make in
                    make!.top.equalTo()
                    make!.height.equalTo()(self.currentHeaderHeight)
                }
            }
        } else {
            self.headerView.mas_updateConstraints { make in
                make!.top.equalTo()(self.currentHeaderHeight - self.headerMaxHeight)
                make!.height.equalTo()(self.headerMaxHeight)
            }
        }
        
        self.delegate?.segmentedView?(self, didChangeHeaderHeightTo: self.currentHeaderHeight)
    }
    
    fileprivate func selectDefaultIndex() {
        var index = self.delegate?.segmentedViewFirstStartSelectIndex?(in: self) ?? 0
        if index < 0 || index >= pageCount {
            index = 0
        }
        currentIndex = index
        self.scrollView(scrollTo: index, animated: false)
        self.segmentedControlView_P?.userScrollExtent(self.scrollView.contentOffset.x/self.frame.width)
        self.addObserver(to: viewArray[index])
    }
    
}

// MARK: Create Layout Views
extension PASegmentedView {
    // 创建header
    fileprivate func createHeader(baseHeader: UIView?, titles: [String]) {
        let minHeight = delegate?.segmentedViewHeaderMinHeight?(in: self)
        let maxHeight = delegate?.segmentedViewHeaderMaxHeight?(in: self)
        let baseHeaderHeight:CGFloat = baseHeader?.frame.height ?? 0
        
        segmentedControlView = delegate?.segmentedViewSegmentedControlView?(in: self)
        let segmentedHeight: CGFloat = segmentedControlView?.frame.height ?? 0.0
        
        headerMinHeight = (minHeight ?? baseHeaderHeight) + segmentedHeight
        headerMaxHeight = (maxHeight ?? baseHeaderHeight) + segmentedHeight
        currentHeaderHeight = headerMaxHeight
        if headerView == nil {
            headerView = BaseHeaderView()
            headerView.backgroundColor = UIColor.white
            self.addSubview(headerView)
        } else {
            // 清理headerview的subviews
            for v in self.headerView.subviews {
                v.removeFromSuperview()
            }
        }
        
        headerView.mas_remakeConstraints { (make) in
            make!.top.left().right().equalTo()(self)
            make!.height.mas_equalTo()(self.headerMaxHeight)
        }
        
        if let baseHeader = baseHeader  {
            headerView.addSubview(baseHeader)
            baseHeader.mas_makeConstraints({ (make) in
                make!.top.left().right().equalTo()(self.headerView)
                make!.bottom.equalTo()(self.headerView.mas_bottom)!.offset()(-segmentedHeight)
            })
        }
        
        if segmentedControlView != nil {
            headerView.addSubview(segmentedControlView!)
            segmentedControlView!.mas_makeConstraints { (make) in
                make!.left.bottom().right().equalTo()(self.headerView)
                make!.height.mas_equalTo()(segmentedHeight)
            }
        }
        
        segmentedControlView_P?.setAction({ [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserScroll = false
            strongSelf.removeObserver(from: strongSelf.viewArray[strongSelf.currentIndex])
            strongSelf.addObserver(to: strongSelf.viewArray[index])
            strongSelf.currentIndex = index
            strongSelf.scrollView(scrollTo: index, animated: true)
        })
        segmentedControlView_P?.reloadData(with: titles)
    }
    
    // 添加view到self.scrollView上
    fileprivate func addView(_ view: UIView, to index: Int) {
        switch view {
        case let tableView as UITableView:
            self.disposeTableView(tableView, to: index)
        case let subScrollView as UIScrollView:
            self.disposeScrollView(subScrollView, to: index)
        default:
            self.disposeCommonView(view, to: index)
        }
    }
    
    // 处理普通view，外层套一个scrollview
    fileprivate func disposeCommonView(_ view: UIView, to index: Int) {
        let subScrollView = UIScrollView()
        subScrollView.backgroundColor = UIColor.clear
        self.disposeScrollView(subScrollView, to: index)
        
        let viewHeight = view.frame.height
        subScrollView.addSubview(view)
        view.mas_makeConstraints { (make) in
            make!.left.right().top().bottom().equalTo()(subScrollView)
            make!.width.equalTo()(self.mas_width)
            if viewHeight != 0 {
                make!.height.mas_equalTo()(viewHeight)
            } else {
                make!.height.equalTo()(self.mas_height)
            }
        }
    }
    
    // 处理scrollview
    fileprivate func disposeScrollView(_ subScrollView: UIScrollView, to index: Int) {
        subScrollView.contentInset = UIEdgeInsets.init(top: headerMaxHeight, left: 0, bottom: 0, right: 0)
        subScrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: headerMaxHeight, left: 0, bottom: 0, right: 0)
        subScrollView.contentOffset = CGPoint.init(x: 0, y: -headerMaxHeight)
        subScrollView.isScrollEnabled = true
        self.layoutView(subScrollView, to: index)
    }
    
    // 处理tableView
    fileprivate func disposeTableView(_ tableView: UITableView, to index: Int) {
        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: headerMaxHeight, left: 0, bottom: 0, right: 0)
        
        // 处理tableView.tableHeaderView
        if let view = tableView.tableHeaderView {
            tableView.tableHeaderView = nil
            let viewWidth = UIScreen.main.bounds.width
            let viewHeight = view.frame.height
            view.frame.size.width = viewWidth
            let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: viewHeight + headerMaxHeight))
            tableHeaderView.backgroundColor = UIColor.clear
            tableHeaderView.addSubview(view)
            view.mas_makeConstraints({ (make) in
                make!.left.right().bottom().equalTo()(tableHeaderView)
                make!.height.equalTo()(viewHeight)
            })
            tableView.tableHeaderView = tableHeaderView
        } else {
            let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.headerMaxHeight))
            tableHeaderView.backgroundColor = UIColor.red
            tableView.tableHeaderView = tableHeaderView
        }
        self.layoutView(tableView, to: index)
    }
    
    fileprivate func layoutView(_ view: UIScrollView, to index: Int) {
        self.scrollView.addSubview(view)
        self.viewArray.append(view)
        view.mas_makeConstraints { (make) in
            make!.top.bottom().equalTo()(self.scrollView)
            make!.height.equalTo()(self.mas_height)
            make!.width.equalTo()(self.mas_width)
            if index == 0 {
                make!.left.equalTo()(self.scrollView.mas_left)
            } else {
                make!.left.equalTo()(self.viewArray[index-1].mas_right)
            }
            
            if index == self.pageCount - 1 {
                make!.right.equalTo()(self.scrollView.mas_right)
            }
        }
    }
    
}

// MARK: Observe
extension PASegmentedView {
    fileprivate func addObserver(to scrollView: UIScrollView) {
        scrollView.addObserver(self,
                               forKeyPath: "contentOffset",
                               options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new],
                               context: nil)
        if isRefreshEnable {
            scrollView.addObserver(self,
                                   forKeyPath: "contentInset",
                                   options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new],
                                   context: nil)
        }
    }
    
    fileprivate func removeObserver(from scrollView: UIScrollView) {
        scrollView.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        if isRefreshEnable {
            scrollView.removeObserver(self, forKeyPath: "contentInset", context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = object as? UIScrollView else {
            return
        }
        if isRefreshEnable && keyPath == "contentInset" {
            guard let tableView = scrollView as? UITableView else {
                return
            }
            if tableView.contentInset.top >= MJRefreshHeaderHeight {
                isUserInteractionEnabled = false
                UIView.animate(withDuration: TimeInterval(MJRefreshFastAnimationDuration), animations: {
                    self.headerView.mas_updateConstraints { make in
                        make!.top.equalTo()(MJRefreshHeaderHeight)
                    }
                    self.layoutIfNeeded()
                })
            } else {
                if headerView.mj_origin.y == 0 {
                    return
                }
                UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                    self.headerView.mas_updateConstraints { make in
                        make!.top.equalTo()(0)
                    }
                    self.layoutIfNeeded()
                }, completion: { _ in
                    self.isUserInteractionEnabled = true
                })
            }
        }
        
        if keyPath == "contentOffset" {
            let realOffsetY = scrollView.contentOffset.y + scrollView.contentInset.top
            let tempHeight = headerMaxHeight - realOffsetY
            if tempHeight < headerMinHeight {
                for view in viewArray {
                    if view != viewArray[currentIndex] {
                        view.contentOffset.y += currentHeaderHeight - headerMinHeight
                    }
                }
                currentHeaderHeight = headerMinHeight
            } else {
                currentHeaderHeight = tempHeight
                for view in viewArray {
                    if view != viewArray[currentIndex] {
                        if view is UITableView {
                            view.contentOffset.y = scrollView.contentOffset.y
                        } else {
                            view.contentOffset.y = scrollView.contentOffset.y + headerMaxHeight - headerMinHeight
                        }
                    }
                }
            }
        }
        
    }
    
}

// MARK: ScrollDelegate & ScrollToIndex
extension PASegmentedView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isUserScroll = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if !self.isUserScroll {
                return
            }
            let index = Int((self.frame.width * 0.5 + scrollView.contentOffset.x) / self.frame.width)
            if index == currentIndex {
                return
            }
            self.removeObserver(from: self.viewArray[currentIndex])
            self.addObserver(to: self.viewArray[index])
            currentIndex = index
            self.delegate?.segmentedView?(self, didShow: index)
            self.segmentedControlView_P?.userScrollExtent(scrollView.contentOffset.x/self.frame.width)
            setupPangesture(index: index)
        }
    }
    
    func scrollView(scrollTo index: Int, animated: Bool = true) {
        var width = self.frame.width
        if width == 0 {
            width = UIScreen.main.bounds.width
        }
        let x = width * CGFloat(index)
        let contentOffset = CGPoint.init(x: x, y: 0)
        self.scrollView.setContentOffset(contentOffset, animated: animated)
        self.delegate?.segmentedView?(self, didShow: index)
        setupPangesture(index: index)
    }
    
    private func setupPangesture(index: Int) {
        if !isHeaderScrollEnable { return }
        let currentView = self.viewArray[index]
        if !(currentView is UITableView) {
            return
        }
        
        if isHeaderScrollEnable {
            if let gestureRecognizers = self.gestureRecognizers {
                for ges in gestureRecognizers {
                    if ges is UIPanGestureRecognizer {
                        self.removeGestureRecognizer(ges)
                    }
                }
            }
            self.addGestureRecognizer(currentView.panGestureRecognizer)
        }
    }
    
}
