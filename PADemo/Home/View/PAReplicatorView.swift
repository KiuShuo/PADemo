//
//  PAReplicatorView.swift
//  wanjia2B
//
//  Created by lichao_liu on 2017/11/24.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

class PAReplicatorView: UIView {

    let replicatorLayer = CAReplicatorLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        createReplicatorLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createReplicatorLayer() {
        replicatorLayer.bounds = bounds
        replicatorLayer.anchorPoint = CGPoint(x: 0, y: 0)
        replicatorLayer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(replicatorLayer)

        let rectangle = CALayer()
        rectangle.bounds = CGRect(x: 0, y: 0, width: 1, height: 8)
        rectangle.anchorPoint = CGPoint(x: 0, y: 0)
        rectangle.position = CGPoint(x: 0, y: 4)
        rectangle.cornerRadius = 2
        rectangle.backgroundColor = UIColor.paOrange.cgColor
        replicatorLayer.addSublayer(rectangle)
        
        let moveRectangle = CABasicAnimation(keyPath: "position.y")
        moveRectangle.toValue = rectangle.position.y - 4
        moveRectangle.duration = 0.7
        moveRectangle.repeatCount = HUGE
        moveRectangle.isRemovedOnCompletion = false
        moveRectangle.fillMode = CAMediaTimingFillMode.forwards
        rectangle.add(moveRectangle, forKey: nil)
        
        replicatorLayer.instanceCount = 14
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(4, 0, 0)
        replicatorLayer.instanceDelay = 0.2
        replicatorLayer.masksToBounds = true
    }
    
    func pauseAnimation() {
        replicatorLayer.sublayers?.forEach({ subl in
            let pauseTime = subl.convertTime(CACurrentMediaTime(), from: nil)
            subl.timeOffset = pauseTime
            subl.speed = 0
        })
    }
    
    func resumeAnimation() {
        replicatorLayer.sublayers?.forEach({ subl in
         let pauseTime = subl.timeOffset
            subl.speed = 1
            let begin = CACurrentMediaTime() - pauseTime
            subl.timeOffset = 0
            subl.beginTime = begin
        })
    }
}
