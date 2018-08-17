//
//  PATeethCheckCell.swift
//  wanjia2B
//
//  Created by shuo on 2018/7/10.
//  Copyright © 2018年 pingan. All rights reserved.
//  牙体检查cell

import UIKit

class PATeethCheckCell: UITableViewCell, PATableViewCellProtocol {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    var dataModel: PAModelBaseProtocol? {
        didSet {
            
        }
    }
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = UIColor.clear
    }
    
}
