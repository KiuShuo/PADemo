//
//  PAMovingDossierTableFooterView.swift
//  wanjia2B
//
//  Created by shuo on 2018/6/16.
//  Copyright © 2018年 pingan. All rights reserved.
//

import UIKit

class PAMovingDossierTableFooterView: UIView {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var end: (() -> Void)?
    var save: (() -> Void)?
    
    class func instanceFromXib(frame: CGRect) -> PAMovingDossierTableFooterView {
        let view = Bundle.main.loadNibNamed("PAMovingDossierTableFooterView", owner: nil, options: nil)?.first as! PAMovingDossierTableFooterView
        view.frame = frame
        return view
    }

    @IBAction func clickLeftButton(_ sender: UIButton) {
        end?()
    }
    
    @IBAction func clickRightButton(_ sender: UIButton) {
        save?()
    }

}
