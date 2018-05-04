//
//  PATopImageBottomTitleButton.swift
//  feng
//
//  Created by luozhijun on 2016/12/4.
//  Copyright © 2016年 shuo. All rights reserved.
//

import UIKit

/** 子视图(imageView和titleLabel)错位的button */
class PAOffsetedSubviewButton: UIButton {
    
    static let imageTopTitleBottom = 1
    static let imageRightTitleLeft = 2
    
    fileprivate var style = PAOffsetedSubviewButton.imageTopTitleBottom
    
    /**
     *  内部图片占整个button的高度比例, 默认为0.65
     *  - note 如果小于0.01 或者 大于1 则忽略此值, 改用titleLabel所需具体高度确定image和Label的高度, 只在style为'imageTopTitleBottom'有效
     */
   fileprivate var imageHeightRatio: CGFloat = 0.65
    /**
     只在style为'imageRightTitleLeft'有效, 如果≤0, 则使用图片默认size
     */
   fileprivate var imageWidthRatio: CGFloat = 0
    /**
     只在style为'imageRightTitleLeft'有效, 默认为3.0; 如果≤0, 则取0.
     */
    var horizontalGapBetweenImageViewAndTitleLabel: CGFloat = 3.0
    
    fileprivate var imageRounded = false
    
    required init(imageHeightRatio: CGFloat = 0.65, imageWidthRatio: CGFloat = 0, imageRounded: Bool = false, style: Int) {
        super.init(frame: .zero)
        self.style = style
        self.setValue(NSNumber(value: UIButtonType.system.rawValue), forKey: "buttonType")
        self.adjustsImageWhenHighlighted = false
        baseSetting()
        self.imageHeightRatio = imageHeightRatio
        self.imageRounded = imageRounded
        imageView?.clipsToBounds = imageRounded
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        baseSetting()
    }
    
    private func baseSetting() {
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 只在imageView和titleLabel同时占用了空间时才采用自定义布局
        guard let imageView = imageView, let titleLabel = titleLabel, imageView.frame.width > 0.01, titleLabel.frame.width > 0.01 else { return }
        
        let constraintSize = CGSize(width: frame.width, height: frame.height)
        
        let titleLabelNeedSize = titleLabel.sizeThatFits(constraintSize)
        var titleH: CGFloat = 0
        var imageH: CGFloat = 0
        var titleW: CGFloat = titleLabelNeedSize.width
        var imageW = imageView.frame.size.width
        var imageX: CGFloat = 0
        var imageY: CGFloat = imageView.frame.origin.y
        var titleX: CGFloat = (frame.width - contentEdgeInsets.left - titleEdgeInsets.left - titleW - imageEdgeInsets.left - imageW - contentEdgeInsets.right)/2.0
        var titleY: CGFloat = (frame.size.height - titleLabelNeedSize.height)/2.0
        
        if style == PAOffsetedSubviewButton.imageTopTitleBottom {
            if imageHeightRatio > 0.01 && imageHeightRatio <= 1 {
                titleH = frame.size.height * (1 - imageHeightRatio)
                imageH = frame.size.height * imageHeightRatio
            } else {
                titleH = titleLabelNeedSize.height
                imageH = frame.size.height - titleH
            }
            // (imageView多余空白/2.0 + titleLabel多余空白/2.0)/4.0
            var imageHeightSpace = (imageH -  imageH) / 2.0
            if let imageViewHeight = imageView.image?.size.height {
                imageHeightSpace = (imageH -  imageViewHeight) / 2.0
            }
            let titleHeight: CGFloat = titleLabel.sizeThatFits(constraintSize).height
            let titleHeightSpace = (titleH - titleHeight)/2.0
            let commonMargin = (imageHeightSpace + titleHeightSpace)/4.0
            
            imageX = (frame.size.width - imageW) / 2.0
            imageY = commonMargin
            
            titleX = (frame.size.width - titleLabelNeedSize.width) / 2.0
            titleY = frame.size.height - titleH - 2.0 * commonMargin
        } else if style == PAOffsetedSubviewButton.imageRightTitleLeft {
            if imageWidthRatio > 0.01 && imageWidthRatio <= 1 {
                imageW = frame.width * imageWidthRatio
                titleW = frame.width * (1 - imageWidthRatio)
            }
            titleH = titleLabelNeedSize.height
            imageH = imageView.frame.height
            imageX = titleX + titleLabelNeedSize.width + imageEdgeInsets.left
        }
        
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
        if imageRounded {
            imageView.layer.cornerRadius = imageW / 2.0
        }
        
    }
}
