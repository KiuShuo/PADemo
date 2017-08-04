//
//  PAFpsViewTableViewCell.swift
//  PADemo
//
//  Created by shuo on 2017/8/3.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PAFpsViewTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 80)
        layoutIfNeeded()
    }
    
    lazy var bottomViews: [UIView] = {
        var bottomViews: [UIView] = []
        for i in 0..<8 {
            if let bottomView = self.contentView.viewWithTag(1000 + i) {
                bottomViews.append(bottomView)
                
            }
        }
        return bottomViews
    }()
    
    func setCornerRadius() {
        for subView in bottomViews {
            if subView.tag - 1000 < 4 {
                subView.clipAsync(radius: subView.frame.size.height / 2)
            } else {
                subView.drawRoundedCorner(radius: subView.frame.size.height / 2, fillColor: UIColor.green)
            }
        }
    }
    
}
