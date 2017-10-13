//
//  CustomTableViewCell.swift
//  PADemo
//
//  Created by shuo on 2017/5/19.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        debugLog(String(describing: self.classForCoder) + "创建")
    }
    
    deinit {
        debugLog(String(describing: self.classForCoder) + "析构方法执行")
    }
    
    // 重写下面的两个函数可以避免当点击cell的时候 cell上的子视图颜色变为clear
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rightView.backgroundColor = UIColor.red
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        rightView.backgroundColor = UIColor.red
    }
    
}
