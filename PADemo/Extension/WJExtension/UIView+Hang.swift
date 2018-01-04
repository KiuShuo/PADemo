//
//  UIView+Hang.swift
//  WJExtension
//
//  Created by 靳朋 on 2017/6/21.
//  Copyright © 2017年 wanjia. All rights reserved.
//

import UIKit

extension UIView {
    
    private static var hangAssociateKey = "hangAssociateKey"
    
    public func addHangGesture(style: [HangManager.HangType] = [.right], edgeSpace: UIEdgeInsets = UIEdgeInsets.zero) {
        let hang = HangManager(view: self, style: style, edgeSpace: edgeSpace)
        objc_setAssociatedObject(self, &UIView.hangAssociateKey, hang, .OBJC_ASSOCIATION_RETAIN)
    }
}

public class HangManager {
    
    public struct HangType : OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public static let freedom = HangType(rawValue: 0)
        public static let left = HangType(rawValue: 1 << 0)
        public static let right = HangType(rawValue: 1 << 1)
        public static let top = HangType(rawValue: 1 << 2)
        public static let bottom = HangType(rawValue: 1 << 3)
    }
    
    private weak var view: UIView?
    private let pan: UIPanGestureRecognizer
    private let style: [HangType]
    private let edgeSpace: UIEdgeInsets
    
    init(view: UIView, style: [HangType], edgeSpace: UIEdgeInsets) {
        self.view = view
        self.style = style
        self.edgeSpace = edgeSpace
        pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panMove(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc private func panMove(gesture:UIPanGestureRecognizer) {
        guard let view = view else{ return }
        let point = gesture.translation(in: view)
        if style.contains(.freedom) || style.count >= 2 {
            moveView(x: point.x, y: point.y)
        }else if style.contains(.left) || style.contains(.right){
            moveView(x: 0, y: point.y)
        }else if style.contains(.bottom) || style.contains(.top){
            moveView(x: point.x, y: 0)
        }
        gesture.setTranslation(CGPoint.zero, in: view)
    }
    
    private func moveView(x: CGFloat, y: CGFloat) {
        var center = CGPoint(x: view!.center.x + x, y: view!.center.y + y)
        let viewSize: CGSize = view!.frame.size
        var superViewSize: CGSize = CGSize.zero
        if let superView = view?.superview {
            superViewSize = superView.frame.size
        }
        //center X,Y 最小最大值
        let minCenterX = viewSize.width / 2 + self.edgeSpace.left
        let maxCenterX = superViewSize.width - viewSize.width / 2 - self.edgeSpace.right
        let minCenterY = viewSize.height / 2 + self.edgeSpace.top
        let maxCenterY = superViewSize.height - viewSize.height / 2 - self.edgeSpace.bottom
        
        if center.x < minCenterX{
            center.x = minCenterX
        }
        if center.x > maxCenterX{
            center.x = maxCenterX
        }
        if center.y < minCenterY{
            center.y = minCenterY
        }
        if center.y > maxCenterY{
            center.y = maxCenterY
        }
        view?.center = center
        
        let stateArr: [UIGestureRecognizerState] = [.ended,.failed,.cancelled]
        if stateArr.contains(pan.state) && !style.contains(.freedom){
            // 手势结束后，动画移动view位置
            let spaceLeft:(CGFloat, HangType)  = (center.x - minCenterX, HangType.left)
            let spaceRight:(CGFloat, HangType) = (maxCenterX - center.x, HangType.right)
            let spaceTop:(CGFloat, HangType) = (center.y - minCenterY, HangType.top)
            let spaceBottom:(CGFloat, HangType) = (maxCenterY - center.y, HangType.bottom)
            //排序，最靠近哪侧，移动至那边
            let spaceArr: [(CGFloat, HangType)] = [spaceLeft,spaceRight,spaceTop,spaceBottom].sorted(by: { (last, next) -> Bool in
                return last.0 < next.0
            })
            for space in spaceArr {
                let type = space.1
                if style.contains(type) {
                    switch type {
                    case HangType.left:
                        center.x = minCenterX
                    case HangType.right:
                        center.x = maxCenterX
                    case HangType.top:
                        center.y = minCenterY
                    case HangType.bottom:
                        center.y = maxCenterY
                    default:
                        break
                    }
                    break
                }
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.view?.center = center
            })
        }
    }
    
    deinit {
        view?.removeGestureRecognizer(pan)
    }
    
}
