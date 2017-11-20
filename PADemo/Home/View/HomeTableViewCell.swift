//
//  HomeTableViewCell.swift
//  PADemo
//
//  Created by shuo on 2017/8/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell, PATableViewCellProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            guard let controllerModel = dataModel as? ControllerModel else {
                return
            }
            titleLabel.text = controllerModel.identifier
            detailLabel.text = controllerModel.descriotion
        }
    }
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let width = size.width
//        let labelSize = CGSize(width: UIScreen.width - 20, height: CGFloat.greatestFiniteMagnitude)
//        let height = 48 + detailLabel.sizeThatFits(labelSize).height
//        return CGSize(width: width, height: height)
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
