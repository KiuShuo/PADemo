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
//        addShadowView()
        contentView.backgroundColor = UIColor.paBackground
        backgroundColor = UIColor.paBackground
    }
    
    func addShadowView() {
        let view = UIView()
//        contentView.addSubview(view)
        contentView.insertSubview(view, at: 0)
        view.mas_makeConstraints { (make) in
            make!.top.equalTo()
            make!.left.equalTo()(2)
            make!.right.equalTo()(-2)
            make!.bottom.equalTo()(0)
        }
        view.backgroundColor = UIColor.green
        view.layoutIfNeeded()
        view.addshadow(top: false, left: true, bottom: false, right: true, shadowRadius: 3)
        view.layer.shadowColor = UIColor.red.cgColor
    }

}
