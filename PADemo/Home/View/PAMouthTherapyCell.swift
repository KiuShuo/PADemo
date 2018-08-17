//
//  PAMouthTherapyCell.swift
//  wanjia2B
//
//  Created by shuo on 2018/7/10.
//  Copyright © 2018年 pingan. All rights reserved.
//  口腔治疗cell

import UIKit

class PAMouthTherapyCell: UITableViewCell, PATableViewCellProtocol {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var numLabelHeight: NSLayoutConstraint!
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            if let model = dataModel as? DetailModel {
                numLabel.text = model.aNumber
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
}
