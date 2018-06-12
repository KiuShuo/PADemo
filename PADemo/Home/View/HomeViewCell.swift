//
//  HomeViewCell.swift
//  PADemo
//
//  Created by shuo on 2018/6/12.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell, PATableViewCellProtocol {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            guard let controllerModel = dataModel as? ControllerModel else {
                return
            }
            titleLabel.text = controllerModel.identifier
            detailLabel.text = controllerModel.descriotion
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
