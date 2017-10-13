//
//  PATableViewModelDemoCell.swift
//  PADemo
//
//  Created by shuo on 2017/6/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PATableViewModelDemoCell: UITableViewCell, PATableViewCellProtocol {

    static let cellModel: PACellModel = PACellModel(classType: PATableViewModelDemoCell.self, height: -1)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    struct PATableViewModel {
        var title: String?
    }
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            if let model = dataModel as? PAPerson {
                titleLabel.text = model.name
                ageLabel.text = "\(model.age)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        debugLog(String(describing: self.classForCoder) + "创建")
    }
    
    deinit {
        debugLog(String(describing: self.classForCoder) + "析构方法执行")
    }
    
}
