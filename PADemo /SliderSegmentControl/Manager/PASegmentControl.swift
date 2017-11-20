//
//  PASegmentControl.swift
//  PASegmentControl
//
//  Created by shuo on 2017/7/3.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

/// 常用扩展
extension PASegmentControl {
    
    static func baseSegmentControl(frame: CGRect, titles: [String]) -> PASegmentControl {
        let segmentControl = PASegmentControl(frame: frame)
        segmentControl.segmentWidthStyle = .fixed
        
        segmentControl.backgroundColor = UIColor.white
        segmentControl.titles = titles
        segmentControl.selectionIndicatorHeight = 2.0
        
        segmentControl.selectionIndicatorColor = UIColor.paOrange
        segmentControl.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName: UIColor.paGray]
        segmentControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName: UIColor.paOrange]
        
        
        return segmentControl
    }
    
}

class PASegmentControl: UIView {
    
    public enum SegmentWidthStyle {
        case fixed
        case dynamic
        case equal(width: CGFloat)
    }
    
    public enum SelectionIndicatorPosition {
        case top
        case bottom
        case none
    }
    
    
    // MARK: - Public Properties
    
    public var titles: [String] = []
    public var indexChangedHandler: ((_ index: Int) -> (Void))?
    
    public var segmentWidthStyle: SegmentWidthStyle = .fixed
    public var segmentEdgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    public var selectionIndicatorHeight: CGFloat = 5.0
    public var selectionIndicatorEdgeInset: UIEdgeInsets = .zero
    public var selectionIndicatorColor: UIColor = .black {
        didSet {
            self.selectionIndicator.backgroundColor = selectionIndicatorColor
        }
    }
    public var selectionIndicatorPosition: SelectionIndicatorPosition = .bottom {
        didSet {
            if self.superview == nil {
                return
            }
            if let layout = indicatorPositionConstraint {
                layout.isActive = false
            }
            switch selectionIndicatorPosition {
            case .top:
                indicatorPositionConstraint = selectionIndicator.pa_alignTopToParent()
            case .bottom:
                indicatorPositionConstraint = selectionIndicator.pa_alignBottomToParent()
            case .none:
                break
            }
        }
    }
    
    public var titleTextAttributes: [String: AnyObject] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: UIColor.black
        ] {
        didSet {
            set(titleAttributes: titleTextAttributes, forControlState: .normal)
        }
    }
    
    public var selectedTitleTextAttributes: [String: AnyObject] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: UIColor.black
        ] {
        didSet {
            set(titleAttributes: selectedTitleTextAttributes, forControlState: .selected)
        }
    }
    
    public fileprivate(set) var selectedSegmentIndex: Int = 0
    
    // MARK: - Private Properties
    
    //Contraints
    fileprivate var indicatorLeadingConstraint: NSLayoutConstraint?
    fileprivate var indicatorWidthConstraint: NSLayoutConstraint?
    fileprivate var indicatorPositionConstraint: NSLayoutConstraint?
    
    fileprivate var segmentWidth: CGFloat = 0
    fileprivate var segmentWidths: [CGFloat] = []
    
    fileprivate lazy var segmentCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.scrollsToTop = false
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        collection.register(PASegmentCell.self, forCellWithReuseIdentifier: "Cell")
        
        return collection
    }()
    
    fileprivate lazy var selectionIndicator: UIView = {
        let selectionIndicator = UIView()
        selectionIndicator.backgroundColor = self.selectionIndicatorColor
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        return selectionIndicator
    }()
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        addSubview(segmentCollection)
        addSubview(selectionIndicator)
        bringSubview(toFront: selectionIndicator)
    }
    
    public override func updateConstraints() {
        
        calcSegmentWidth()
        
        //collection view
        segmentCollection.pa_alignToParent()
        
        //selection indicator
        if selectionIndicatorPosition != .none {
            selectionIndicator.pa_setHeight(selectionIndicatorHeight)
            indicatorLeadingConstraint = selectionIndicator.pa_alignLeftToParent()
            indicatorWidthConstraint = selectionIndicator.pa_setWidth()
            switch selectionIndicatorPosition {
            case .top:
                indicatorPositionConstraint = selectionIndicator.pa_alignTopToParent()
            case .bottom:
                indicatorPositionConstraint = selectionIndicator.pa_alignBottomToParent()
            default:
                break
            }
        }
        updateSelectionIndicator()
        
        super.updateConstraints()
    }

}

// MARK: - Public Methods
extension PASegmentControl {
    
    public func setSelectedSegmentIndex(_ index: Int, animated: Bool) {
        guard index < itemsCount else {
            return
        }
        
        selectedSegmentIndex = index
        
        scrollToSelectedSegmentIndex(animated: animated)
        updateSelectionIndicator()
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            })
        } else {
            self.layoutIfNeeded()
        }
    }
    
    public func reloadSegments() {
        layoutIfNeeded()
        calcSegmentWidth()
        segmentCollection.reloadData()
        if selectedSegmentIndex < itemsCount {
            segmentCollection.selectItem(at: IndexPath(item: selectedSegmentIndex, section: 0)
                , animated: false, scrollPosition: .left)
        }
        
        updateSelectionIndicator()
    }

}

// MARK: - Private Methods
fileprivate extension PASegmentControl {
    
    fileprivate var itemsCount: Int {
        return titles.count
    }
    
    fileprivate func calcSegmentWidth() {
        
        if bounds.equalTo(.zero) {
            return
        }
        
        if itemsCount > 0 {
            segmentWidth = bounds.width / CGFloat(itemsCount)
        }
        
        switch segmentWidthStyle {
        case .fixed:
            for i in 0 ..< itemsCount {
                let width = widthOfContentAt(index: i)
                segmentWidth = max(width + segmentEdgeInset.left + segmentEdgeInset.right, segmentWidth)
            }
        case .dynamic:
            segmentWidths.removeAll()
            for i in 0 ..< itemsCount {
                let width = widthOfContentAt(index: i)
                segmentWidths.append(width + segmentEdgeInset.left + segmentEdgeInset.right)
            }
        case .equal(let width):
            segmentWidth = width
        }
    }
    
    fileprivate func widthOfSegmentAt(index: Int) -> CGFloat {
        switch segmentWidthStyle {
        case .fixed, .equal(_):
            return segmentWidth
        case .dynamic:
            if index >= segmentWidths.count {
                return 0
            }
            return segmentWidths[index]
        }
    }
    
    fileprivate func widthOfContentAt(index: Int) -> CGFloat {
        guard index < itemsCount else {
            return 0
        }
        var textWidth: CGFloat = 0
        let text = titles[index]
        textWidth = ceil((text as NSString).size(attributes: titleTextAttributes).width)
        return textWidth
    }
    
    fileprivate func updateSelectionIndicator() {
        
        selectionIndicator.isHidden = false
        
        var offsetX: CGFloat = 0.0
        for i in 0 ..< selectedSegmentIndex {
            offsetX = offsetX + widthOfSegmentAt(index: i)
        }
        let selectedSegmentWidth = widthOfSegmentAt(index: selectedSegmentIndex)
        let edgeInset = selectionIndicatorEdgeInset.left + selectionIndicatorEdgeInset.right
        offsetX += selectionIndicatorEdgeInset.left
        indicatorWidthConstraint?.constant = selectedSegmentWidth - edgeInset
        
        indicatorLeadingConstraint?.constant = offsetX - segmentCollection.contentOffset.x
        
        switch selectionIndicatorPosition {
        case .top:
            indicatorPositionConstraint?.constant = selectionIndicatorEdgeInset.top
        case .bottom:
            indicatorPositionConstraint?.constant = selectionIndicatorEdgeInset.bottom
        case .none:
            selectionIndicator.isHidden = true
        }
    }
    
    fileprivate func scrollToSelectedSegmentIndex(animated: Bool) {
        segmentCollection.selectItem(at: IndexPath(item: selectedSegmentIndex, section: 0), animated: animated, scrollPosition: .centeredHorizontally)
    }
    
    fileprivate func set(titleAttributes attributes: [String: AnyObject], forControlState state: UIControlState) {
        for cell in segmentCollection.visibleCells {
            if let textCell = cell as? PASegmentCell,
                let title = textCell.displayButton.title(for: state) {
                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                textCell.displayButton.setAttributedTitle(attributedTitle, for: state)
            }
        }
    }

}

// MARK: - UICollectionViewDataSource
extension PASegmentControl: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PASegmentCell
        
        //text
        let title = titles[indexPath.item]
        cell.displayButton.setTitle(title, for: .normal)
        
        let attrTitle = NSAttributedString(string: title, attributes: titleTextAttributes)
        cell.displayButton.setAttributedTitle(attrTitle, for: .normal)
        
        let selectedAttrTitle = NSAttributedString(string: title, attributes: selectedTitleTextAttributes)
        cell.displayButton.setAttributedTitle(selectedAttrTitle, for: .selected)
        
        
        cell.contentEdgeInset = segmentEdgeInset
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PASegmentControl: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize( width: widthOfSegmentAt(index: indexPath.item), height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexChanged: Bool = indexPath.item != selectedSegmentIndex
        
        selectedSegmentIndex = indexPath.item
        if indexChanged {
            indexChangedHandler?(selectedSegmentIndex)
        }
        
        setSelectedSegmentIndex(selectedSegmentIndex, animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == segmentCollection else {
            return
        }
        
        updateSelectionIndicator()
    }

}

// MARK: - Segment Cell
fileprivate class PASegmentCell: UICollectionViewCell {
    
    var displayButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var contentEdgeInset: UIEdgeInsets = .zero {
        didSet {
            displayButtonTopContraint?.constant = contentEdgeInset.top
            displayButtonLeftContraint?.constant = contentEdgeInset.left
            displayButtonBottomContraint?.constant = -contentEdgeInset.bottom
            displayButtonRightContraint?.constant = -contentEdgeInset.right
        }
    }
    
    fileprivate var displayButtonTopContraint: NSLayoutConstraint?
    fileprivate var displayButtonLeftContraint: NSLayoutConstraint?
    fileprivate var displayButtonBottomContraint: NSLayoutConstraint?
    fileprivate var displayButtonRightContraint: NSLayoutConstraint?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        displayButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(displayButton)
        displayButtonTopContraint = displayButton.pa_alignTopToParent()
        displayButtonLeftContraint = displayButton.pa_alignLeftToParent()
        displayButtonBottomContraint = displayButton.pa_alignBottomToParent()
        displayButtonRightContraint = displayButton.pa_alignRightToParent()
    }
    
    override var isSelected: Bool {
        didSet {
            displayButton.isSelected = isSelected
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
