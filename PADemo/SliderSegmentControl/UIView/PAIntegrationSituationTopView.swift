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
        // super.awakeFromNib()
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handelPanGesture(_:)))
//        addGestureRecognizer(panGesture)
    }
    
    class func instanceFromXib() -> PAIntegrationSituationTopView {
        let view = Bundle.main.loadNibNamed("PAIntegrationSituationTopView", owner: nil, options: nil)?.first as! PAIntegrationSituationTopView
        return view
    }
    
    func handelPanGesture(_ panGesture: UIPanGestureRecognizer) {
        delegate?.didPan(panGesture: panGesture)
    }

}
