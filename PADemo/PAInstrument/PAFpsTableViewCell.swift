//
//  PAFpsTableViewCell.swift
//  PADemo
//
//  Created by shuo on 2017/7/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PAFpsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 80)
        layoutIfNeeded()
        contentView.backgroundColor = UIColor.white
    }
    
    lazy var imageViews: [UIImageView] = {
        var imageViews: [UIImageView] = []
        for i in 0..<12 {
            if let subImageView = self.contentView.viewWithTag(1000 + i) as? UIImageView {
                imageViews.append(subImageView)
            }
        }
        return imageViews
    }()
    
    func setCornerRadius(subImageView: UIImageView) {
        subImageView.contentMode = .scaleToFill
        subImageView.layer.cornerRadius = 10
        subImageView.layer.masksToBounds = true
        // subImageView.layer.shouldRasterize = true
    }
    
    func configureImageView() {
        for subImageView in imageViews {
            let image = UIImage(named: "HealthProductDetals")
            //subImageView.image = image
            
            // 使用系统方式切圆角 缺点：iOS10之前会有离屏渲染，造成帧率下降，影响用户体验
            // setCornerRadius(subImageView: subImageView)
            if subImageView.tag - 1000 < 6 {
            // 异步切割视图
            subImageView.clipImageAsync(image: image, radius: subImageView.frame.size.height / 2)
            } else {
                subImageView.drawRoundedCorner(image: image, radius: subImageView.frame.size.height / 2, fillColor: UIColor.green)
            }
        }
    }
    
}
