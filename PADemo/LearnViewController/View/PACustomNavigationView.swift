//
//  PACustomNavigationView.swift
//  PADemo
//
//  Created by shuo on 2017/12/10.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PACustomNavigationView: UIView {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var tapBackButton: (() -> Void)?
    
    class func instanceFromXib() -> PACustomNavigationView {
        let view = Bundle.main.loadNibNamed("PACustomNavigationView", owner: nil, options: nil)?.first as! PACustomNavigationView
        return view
    }

    @IBAction func clickBackButton(_ sender: UIButton) {
        tapBackButton?()
    }
}
