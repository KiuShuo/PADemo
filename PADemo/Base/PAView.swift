//
//  PAView.swift
//  feng
//
//  Created by shuoliu on 16/6/17.
//  Copyright © 2016年 shuo. All rights reserved.
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
            self.layer.borderWidth = borderWidth / UIScreen.main.scale
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    class func createSeperatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.paDividing
        return view
    }
    
    func maskLayer(cornerRadius: CGSize, rectCorner: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCorner, cornerRadii: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
        layer.masksToBounds = true
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
            self.layer.borderWidth = borderWidth / UIScreen.main.scale
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.shouldRasterize = true
        }
    }
    // 添加竖直方向的对齐方式
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }
    
    var verticalAlignment: VerticalAlignment = .middle {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawText(in rect: CGRect) {
        let actualRect = textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch verticalAlignment {
        case .top:
            textRect.origin.y = bounds.origin.y
        case .bottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
        }
        return textRect
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
            self.layer.borderWidth = borderWidth / UIScreen.main.scale
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
    @IBInspectable var highlightedBackgroundColor: UIColor = UIColor.init(withRGBValue: 0xECECEC) {
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
    
    @IBInspectable var highlightedTitleColor: UIColor = UIColor.init(withRGBValue: 0xFF6602) {
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
        guard let color = color else {
            return
        }
        let image = UIImage(color: color, size: self.frame.size)
        self.setBackgroundImage(image, for: state)
    }
    
    
    var clickBlock: (() -> Void)? = nil
    
    func addClickEvent(click: (() -> Void)? = nil) {
        clickBlock = click
        self.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    @objc func clickButton() {
        if let clickBlock = clickBlock {
            clickBlock()
        }
    }
    
}
