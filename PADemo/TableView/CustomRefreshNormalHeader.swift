//
//  CustomRefreshNormalHeader.swift
//  PADemo
//
//  Created by shuo on 2017/12/11.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import MJRefresh

class CustomRefreshNormalHeader: MJRefreshNormalHeader {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func placeSubviews() {
        super.placeSubviews()
        
    }
    
    override func prepare() {
        super.prepare()
        mj_h += UIScreen.navigationHeight
    }
    

}
