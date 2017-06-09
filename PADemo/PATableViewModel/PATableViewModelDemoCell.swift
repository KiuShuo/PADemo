//
//  PATableViewModelDemoCell.swift
//  PADemo
//
//  Created by shuo on 2017/6/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PATableViewModelDemoCell: UITableViewCell, PATableViewCellProtocol {

    static let cellModel: PACellModel = PACellModel(classType: PATableViewModelDemoCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    struct PATableViewModel {
        var title: String?
    }
    
    var dataModel: Any? {
        didSet {
            if let model = dataModel as? String {
                titleLabel.text = model
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
