//
//  PACalculatorMainMenuCell.swift
//  PADemo
//
//  Created by shuo on 2017/9/1.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PACalculatorMainMenuCell: UITableViewCell, PATableViewCellProtocol {
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            guard let model = dataModel as? PACalculatorMainMenuModel else {
                return
            }
            departButton.titleLabel?.numberOfLines = 0
            departButton.titleLabel?.textAlignment = .center
            departButton.setTitle(model.mainMenuName, for: .normal)
            let selectedTitle = "\(model.mainMenuName)\n\(model.detailMenuList.count)"
            departButton.setTitle(selectedTitle, for: .selected)
        }
    }

    @IBOutlet weak var departButton: PAButton!
    var tapButton: ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = UIColor(withRGBValue: 0xd9d9d9)
        backgroundColor = UIColor(withRGBValue: 0xd9d9d9)
    }
    
    @IBAction func clickDepartButton(_ sender: PAButton) {
        tapButton?(sender)
    }
}
