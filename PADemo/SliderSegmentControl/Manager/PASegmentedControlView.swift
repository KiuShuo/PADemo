//
//  PASegmentedControl.swift
//  wanjia2B
//
//  Created by 邵伟男 on 2017/5/26.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit
import Masonry

class PASegmentedControlView: UIView {
    enum SeparateStyle {
        case none
        case top
        case bottom
        case topAndBottom
    }
    
    enum SelectionIndicatorPosition {
        case top
        case bottom
        case none
    }
    
    fileprivate lazy var selectionIndicator: UIView = {
        let selectionIndicator = UIView()
        selectionIndicator.backgroundColor = self.selectionIndicatorColor
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        return selectionIndicator
    }()
    
    var selectionIndicatorHeight: CGFloat = 2 {
        didSet {
            selectionIndicator.mas_updateConstraints { make in
                make!.height.equalTo()(self.selectionIndicatorHeight)
            }
        }
    }
    
    var selectionIndicatorColor: UIColor = UIColor.paOrange {
        didSet {
            self.selectionIndicator.backgroundColor = selectionIndicatorColor
        }
    }
    
    var selectionIndicatorPosition: SelectionIndicatorPosition = .none {
        didSet {
            switch selectionIndicatorPosition {
            case .top:
                selectionIndicator.isHidden = false
                selectionIndicator.mas_updateConstraints { make in
                    make!.top.equalTo()
                }
            case .bottom:
                selectionIndicator.isHidden = false
                selectionIndicator.mas_updateConstraints { make in
                    make!.top.equalTo()(self.frame.size.height - self.selectionIndicatorHeight)
                }
            case .none:
                selectionIndicator.isHidden = true
            }
        }
    }
    
    fileprivate(set) var currentIndex: Int = -1 {
        didSet {
            if oldValue == currentIndex {
                return
            }
            if oldValue >= 0 && oldValue < controls.count  {
                controls[oldValue].isSelected = false
            }
            if currentIndex >= 0 && currentIndex < controls.count {
                controls[currentIndex].isSelected = true
                self.updateIndicatorMasonry()
            } else {
                currentIndex = 0
            }
        }
    }
    
    var separateStyle: SeparateStyle = .topAndBottom {
        didSet {
            self.changeSeparateStyle()
        }
    }
    
    var actionBlock: ((_ index: Int) -> ())?
    
    var titles: [String]! {
        didSet {
            self.creatViews(with: titles)
        }
    }
    
    var normalColor = UIColor.paBlack
    var normalFont = UIFont.systemFont(ofSize: 14)
    var selectColor = UIColor.paOrange
    var selectFont = UIFont.boldSystemFont(ofSize: 15)
    
    private var controls = [PAControl]()
    private var topLine: UIImageView!
    private var bottomLine: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect = CGRect.zero) {
        var frame = frame
        if frame == CGRect.zero {
            frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        }
        super.init(frame: frame)
        
        let color = UIColor.init(withRGBValue: 0xDFDFDF)
        let colorImage = UIImage.init(color: color)
        
        topLine = UIImageView()
        topLine.image = colorImage
        self.addSubview(topLine)
        topLine.mas_makeConstraints { (make) in
            make!.left.right().top().equalTo()(self)
            make!.height.mas_equalTo()(1.0 / UIScreen.main.scale)
        }
        
        bottomLine = UIImageView()
        bottomLine.image = colorImage
        self.addSubview(bottomLine)
        bottomLine.mas_makeConstraints { (make) in
            make!.left.right().bottom().equalTo()(self)
            make!.height.mas_equalTo()(1.0 / UIScreen.main.scale)
        }
        
        selectionIndicator.isHidden = true
        addSubview(selectionIndicator)
        selectionIndicator.mas_makeConstraints { make in
            make!.top.equalTo()(frame.size.height - self.selectionIndicatorHeight)
            make!.height.equalTo()(self.selectionIndicatorHeight)
            make!.left.equalTo()
            make!.width.equalTo()
        }
    }
    
    private func creatViews(with titles: [String]) {
        for v in controls {
            v.removeFromSuperview()
        }
        controls.removeAll()
        
        let count = CGFloat(titles.count)
        for index in 0..<titles.count {
            let control = PAControl()
            control.addTarget(self, action: #selector(self.clickControl(_:)), for: .touchUpInside)
            control.label.text = titles[index]
            control.normalColor = self.normalColor
            control.normalFont = self.normalFont
            control.selectColor = self.selectColor
            control.selectFont = self.selectFont
            control.applyStyle()
            self.addSubview(control)
            control.mas_makeConstraints({ (make) in
                if index == 0 {
                    make!.left.equalTo()(self.mas_left)
                } else {
                    make!.left.equalTo()(self.controls[index-1].mas_right)
                }
                make!.top.bottom().equalTo()(self)
                make!.width.equalTo()(self.mas_width)!.multipliedBy()(1.0/count)
            })
            controls.append(control)
        }
    }
    
    private func updateIndicatorMasonry() {
        let count = CGFloat(titles.count)
        let width = frame.size.width / count
        let masLeft = CGFloat(currentIndex) * width
        selectionIndicator.mas_updateConstraints { make in
            make!.left.equalTo()(masLeft)
            make!.width.equalTo()(width)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func applyStyle() {
        for control in controls {
            control.normalColor = self.normalColor
            control.normalFont = self.normalFont
            control.selectColor = self.selectColor
            control.selectFont = self.selectFont
            control.applyStyle()
        }
    }
    
    private func changeSeparateStyle() {
        switch self.separateStyle {
        case .top:
            topLine.isHidden = false
            bottomLine.isHidden = true
        case .bottom:
            topLine.isHidden = true
            bottomLine.isHidden = false
        case .topAndBottom:
            topLine.isHidden = false
            bottomLine.isHidden = false
        default:
            topLine.isHidden = true
            bottomLine.isHidden = true
        }
    }
    
    @objc private func clickControl(_ control: PAControl) {
        let index = self.controls.index(of: control) ?? 0
        currentIndex = index
        self.actionBlock?(index)
    }
}

extension PASegmentedControlView: PASegmentedControlProtocol {
    func setAction(_ actionBlock: ((Int) -> Void)?) {
        self.actionBlock = actionBlock
    }
    
    func userScrollExtent(_ extent: CGFloat) {
        let index = Int(extent + 0.5)
        currentIndex = index
    }
    
    func reloadData(with titles: [String]) {
        self.titles = titles
    }
}


class PAControl: UIControl {
    
    override var isSelected: Bool {
        didSet {
            self.changeSelected()
        }
    }
    
    var normalColor = UIColor.paBlack
    var normalFont = UIFont.systemFont(ofSize: 14)
    var selectColor = UIColor.paOrange
    var selectFont = UIFont.boldSystemFont(ofSize: 16)
    
    var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setupViews()
    }
    
    
    func setupViews() {
        label = UILabel()
        self.addSubview(label)
        label.mas_makeConstraints { (make) in
            make!.left.top().right().bottom().equalTo()(self)
        }
        label.backgroundColor = UIColor.clear
        label.textColor = self.normalColor
        label.font = self.normalFont
        label.textAlignment = .center
    }
    
    func applyStyle() {
        self.changeSelected()
    }
    
    private func changeSelected() {
        if isSelected {
            label.textColor = self.selectColor
            label.font = self.selectFont
        } else {
            label.textColor = self.normalColor
            label.font = self.normalFont
        }
    }
}
