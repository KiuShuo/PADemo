//
//  LayoutConstraintsExtension.swift
//  LayoutConstraintsExtension
//
//  Created by shuo on 2016/12/26.
//  Copyright © 2016年 shuo. All rights reserved.
//


import UIKit

// !!!使用此类是为了保证封装的独立性
internal extension UIView {
    
    @discardableResult
    func pa_alignTopToParent(with margin: CGFloat = 0) -> NSLayoutConstraint {
        return pa_alignToTop(of: self.superview!, margin: margin, multiplier: 1)
    }
    
    @discardableResult
    func pa_alignToTop(of view: UIView, margin: CGFloat = 0, multiplier: CGFloat) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .top,
                                        multiplier: multiplier,
                                        constant: margin)
        self.superview!.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_alignBottomToParent(with margin: CGFloat = 0) -> NSLayoutConstraint {
        return pa_alignToBottom(of: self.superview!, margin: margin)
    }
    
    @discardableResult
    func pa_alignToBottom(of view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: margin)
        self.superview!.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_alignLeftToParent(with margin: CGFloat = 0) -> NSLayoutConstraint {
        return pa_alignToLeft(of: self.superview!, margin: margin)
    }
    
    @discardableResult
    func pa_alignToLeft(of view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .left,
                                        multiplier: 1,
                                        constant: margin)
        self.superview!.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_alignRightToParent(with margin: CGFloat = 0) -> NSLayoutConstraint  {
        return pa_alignToRight(of: self.superview!, margin: margin)
    }
    
    @discardableResult
    func pa_alignToRight(of view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint  {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .right,
                                        multiplier: 1,
                                        constant: margin)
        self.superview!.addConstraint(layout)
        return layout
    }
    
    func pa_alignToParent(with margin: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        pa_alignTopToParent(with: margin)
        pa_alignLeftToParent(with: margin)
        pa_alignRightToParent(with: margin)
        pa_alignBottomToParent(with: margin)
    }
    
    @discardableResult
    func pa_setHeight(_ height: CGFloat = 0) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: height)
        self.superview!.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_setMaxHeight(_ height: CGFloat = 0) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .lessThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: height)
        self.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_setWidth(_ width: CGFloat = 0) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: width)
        self.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_centerHorizontally() -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .centerX,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .centerX,
                                        multiplier: 1,
                                        constant: 0)
        self.superview!.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_centerVertically(constant: CGFloat = 0) -> NSLayoutConstraint {
        let centerYLayoutConstraint = NSLayoutConstraint(item: self,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: self.superview,
                                                         attribute: .centerY,
                                                         multiplier: 1,
                                                         constant: constant)
        self.superview!.addConstraint(centerYLayoutConstraint)
        return centerYLayoutConstraint
    }
    
    @discardableResult
    func pa_place(below view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: margin)
        self.superview!.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    func pa_place(above view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: margin)
        self.superview!.addConstraint(layout)
        return layout
    }
}
