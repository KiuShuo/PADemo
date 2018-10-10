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
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            guard let controllerModel = dataModel as? ControllerModel else {
                return
            }
            detailLabel.text = controllerModel.identifier + controllerModel.descriotion.noneNull
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
        backgroundColor = UIColor.paBackground
    }
    

}


class HomeTestCell: UITableViewCell, PATableViewCellProtocol {
    
    var detailLabel: UILabel!
    var dataModel: PAModelBaseProtocol? {
        didSet {
            guard let controllerModel = dataModel as? ControllerModel else {
                return
            }
            detailLabel.text = controllerModel.identifier + controllerModel.descriotion.noneNull
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
        backgroundColor = UIColor.paBackground
        detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        contentView.addSubview(detailLabel)
        detailLabel.mas_makeConstraints { (make) in
            make!.left.equalTo()(10)
            make!.top.equalTo()(10)
            make!.right.equalTo()(-10)
            make!.bottom.equalTo()(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

