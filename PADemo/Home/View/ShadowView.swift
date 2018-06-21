//
//  ShadowView.swift
//  PADemo
//
//  Created by shuo on 2018/6/21.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
//        shadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showShadow(top: Bool, left: Bool, bottom: Bool, right: Bool) {
//        clipsToBounds = true
//        layer.cornerRadius = 3
        let shadowView = shadow(frame: self.bounds)
        addSubview(shadowView)
        let x: CGFloat = left ? 2 : 0
        let y: CGFloat = top ? 2 : 0
        let width: CGFloat = right ? bounds.size.width - x - 2 : bounds.size.width - x
        let height: CGFloat = bottom ? bounds.size.height - y - 3 : bounds.size.height - y
        let topFrame = CGRect(x: x, y: y, width: width, height: height)
        let topView = UIView(frame: topFrame)
        topView.backgroundColor = UIColor.white
        addSubview(topView)
    }
    
    func shadow(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.layer.shadowOpacity = 0.3
        let path = UIBezierPath(rect: layer.bounds)
        view.layer.shadowPath = path.cgPath
        view.layer.shadowPath = path.cgPath
        view.layer.shadowColor = UIColor.paGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 0.5
        return view
    }

}
