//
//  PACalculatorDetailMenuCell.swift
//  PADemo
//
//  Created by shuo on 2017/8/31.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PACalculatorDetailMenuCell: UITableViewCell, PATableViewCellProtocol {
    
    static let cellModel: PACellModel = PACellModel(identifier: String(describing: PACalculatorDetailMenuCell.self), height: 50)
    
    @IBOutlet weak var dapartDetailLabel: UILabel!
    var dataModel: PAModelBaseProtocol? {
        didSet {
            guard let model = dataModel as? PACalculatorDetailModel else {
                return
            }
            dapartDetailLabel.text = model.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let seperatorView = PAView.createSeperatorView()
        contentView.addSubview(seperatorView)
        seperatorView.mas_makeConstraints { make in
            make!.left.bottom().right().equalTo()
            make!.height.equalTo()(UIScreen.separatorSize)
        }
    }
    
}
