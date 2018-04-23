//
//  PAIntegrationGuideView.swift
//  PADemo
//
//  Created by shuo on 2018/4/19.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class PAIntegrationGuideView: UIView {
    
    @IBOutlet weak var guideDetailImageViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var guideDetailImageViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var guideArrowImageViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var guideMessageImageViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var guideMessageImageViewCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var guideDetailImageView: UIImageView!
    @IBOutlet weak var guideArrowImageView: UIImageView!
    @IBOutlet weak var guideMessageImageView: UIImageView!
    @IBOutlet weak var guideNextImageView: UIImageView!
    
    private var tapIndex = 0
    
    var didmiss: (() -> Void)?
    
    class func instanceFromXib() -> PAIntegrationGuideView {
        let view = Bundle.main.loadNibNamed("PAIntegrationGuideView", owner: nil, options: nil)?.first as! PAIntegrationGuideView
        let nextTap = UITapGestureRecognizer(target: view, action: #selector(nextAction))
        view.guideNextImageView.addGestureRecognizer(nextTap)
        return view
    }
    
    @objc func nextAction() {
        if tapIndex == 4 {
            didmiss?()
            return
        }
        tapIndex += 1
        guideDetailImageViewCenterX.constant = guideDetailImageViewCenterX.constant + 70
        if tapIndex > 1 {
            guideArrowImageViewCenterX.constant = -12.5
        }
        
        let dMessageViewPoints = [(87.3, 127.5), (8, 121.2), (-0.5, 130.2), (-18.1, 122.1), (-89.3, 132.2)]
        let dMessagePoint = CGPoint(x: dMessageViewPoints[tapIndex].0, y: dMessageViewPoints[tapIndex].1)
        guideMessageImageViewCenterX.constant = dMessagePoint.x
        guideMessageImageViewCenterY.constant = dMessagePoint.y
        
        self.layoutIfNeeded()
        guideDetailImageView.image = UIImage(named: "guide_detail_\(tapIndex)")
//        guideDetailImageView.tintColor = UIColor.paOrange
        guideArrowImageView.image = UIImage(named: "guide_arrow_\(tapIndex)")
        guideMessageImageView.image = UIImage(named: "guide_message_\(tapIndex)")
//        guideMessageImageView.backgroundColor = UIColor.green
        if tapIndex == 4 {
            guideNextImageView.image = #imageLiteral(resourceName: "guide_zhidaole")
        }
    }
    
    
}
