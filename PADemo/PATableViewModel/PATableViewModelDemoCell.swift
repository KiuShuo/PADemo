//
//  PATableViewModelDemoCell.swift
//  PADemo
//
//  Created by shuo on 2017/6/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

extension String: PAModelBaseProtocol {
    
}

class PATableViewModelDemoCell: UITableViewCell {

    static let cellModel: PACellModel = PACellModel(classType: PATableViewModelDemoCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    struct PATableViewModel {
        var title: String?
    }
    
    
    func configureCell(dataModel: PAModelBaseProtocol?) {
        if let model = dataModel as? String {
            titleLabel.text = model
        }
    }
    
//    var dataModel: PAModelBaseProtocol? {
//        didSet {
//            if let model = dataModel as? String {
//                titleLabel.text = model
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
