//
//  PAView.swift
//  wanjia
//
//  Created by shuoliu on 16/6/17.
//  Copyright © 2016年 pingan. All rights reserved.
//

import Foundation

// PAView
@IBDesignable class PAView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    class func createSeperatorView()->UIView {
        let view = UIView()
        view.backgroundColor = UIColor.paDividingColor()
        return view
    }
}

// PALabel
@IBDesignable class PALabel: UILabel {
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.shouldRasterize = true
        }
    }
    
}

// PAButton
@IBDesignable class PAButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// 正常状态显示的颜色
    @IBInspectable var normalColor: UIColor = UIColor.white {
        didSet {
            setBackgroundColor(normalColor, for: .normal)
        }
    }
    
    /// 点击下去显示的颜色
    @IBInspectable var highlightedBackgroundColor: UIColor = UIColor(hexString: "ECECEC")! {
        didSet {
            setBackgroundColor(highlightedBackgroundColor, for: .highlighted)
        }
    }
    
    /// 选中状态的颜色
    @IBInspectable var selectedBackgroundColor: UIColor = UIColor.white {
        didSet {
            setBackgroundColor(selectedBackgroundColor, for: .selected)
        }
    }
    
    @IBInspectable var normalTitleColor: UIColor = UIColor.white {
        didSet {
            self.setTitleColor(normalTitleColor, for: .normal)
        }
    }
    
    @IBInspectable var highlightedTitleColor: UIColor = UIColor(hexString: "FF6602")! {
        didSet {
            self.setTitleColor(highlightedTitleColor, for: .highlighted)
        }
    }
    
    @IBInspectable var selectedTitleColor: UIColor = UIColor.white {
        didSet {
            self.setTitleColor(selectedTitleColor, for: .selected)
        }
    }
    
    private func setBackgroundColor(_ color: UIColor?, for state: UIControlState) {
        guard color != nil else {
            return
        }
//        let image = UIImage(color: color, size: self.frame.size)
//        self.setBackgroundImage(image, for: state)
    }

    
    var clickBlock: (() -> Void)? = nil
    
    func addClickEvent(click: (() -> Void)? = nil) {
        clickBlock = click
        self.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    func clickButton() {
        if let clickBlock = clickBlock {
            clickBlock()
        }
    }
    
}
