//
//  PAIntegrationSituationTopView.swift
//  PADemo
//
//  Created by shuo on 2017/8/10.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

protocol PAViewGestureProtocol: NSObjectProtocol {
    
    func didPan(panGesture: UIPanGestureRecognizer)
    
}

class PAIntegrationSituationTopView: UIView {

    weak var delegate: PAViewGestureProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handelPanGesture(_:)))
//        addGestureRecognizer(panGesture)
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        if view is UIButton {
//            return view
//        }
//        return nil
//    }
    
    class func instanceFromXib() -> PAIntegrationSituationTopView {
        let view = Bundle.main.loadNibNamed("PAIntegrationSituationTopView", owner: nil, options: nil)?.first as! PAIntegrationSituationTopView
        return view
    }
    
    func handelPanGesture(_ panGesture: UIPanGestureRecognizer) {
        delegate?.didPan(panGesture: panGesture)
    }

    @IBAction func clickCenterButton(_ sender: UIButton) {
        print("点击中间按钮")
    }
}
