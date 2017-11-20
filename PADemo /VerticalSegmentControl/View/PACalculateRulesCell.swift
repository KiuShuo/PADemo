//
//  PACalculateRulesCell.swift
//  PADemo
//
//  Created by shuo on 2017/9/13.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PACalculateRulesCell: UITableViewCell, PATableViewCellProtocol {
    
    @IBOutlet weak var ruleLabel: UILabel!
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            guard let model = dataModel as? PACalculatorDetailModel else {
                return
            }
            ruleLabel.text = model.calculateRules
        }
    }

    
}
