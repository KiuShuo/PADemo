//
//  PAFpsFile.swift
//  PADemo
//
//  Created by shuo on 2017/8/3.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation

extension UIImageView {
    
    private static var clipImageKey = "clipImage"
    var clipImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.clipImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.clipImageKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private static var originImageKey = "originImage"
    var originImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.originImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.originImageKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // 异步切割法
    func clipImageAsync(image: UIImage?, radius: CGFloat, roundingCorners: UIRectCorner = .allCorners) {
        guard let image = image else {
            return
        }
        if originImage == image {
            self.image = clipImage
            return
        }
        originImage = image
        self.image = image
        
        let rect = CGRect(origin: CGPoint.zero, size: self.frame.size)
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
            
            let context = UIGraphicsGetCurrentContext()
            let bezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: roundingCorners,
                                           cornerRadii: CGSize(width: radius, height: radius))
            context?.addPath(bezierPath.cgPath)
            bezierPath.addClip()
            // context?.clip()
            self.draw(rect)
            context?.drawPath(using: .fillStroke)
            
            /*
            UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: roundingCorners,
                                                                cornerRadii: CGSize(width: radius, height: radius)).cgPath)
            UIGraphicsGetCurrentContext()?.clip()
            
            self.draw(rect)
            UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
             */
            
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async(execute: {
                self.clipImage = outputImage
                self.image = outputImage
            })
        }
    }
    
    // 粘贴圆角法
    override func drawRoundedCorner(image: UIImage?, radius: CGFloat, roundingCorners: UIRectCorner = .allCorners, fillColor: UIColor) {
        super.drawRoundedCorner(image: nil, radius: radius, roundingCorners: roundingCorners, fillColor: fillColor)
        self.image = image
    }
    
}

extension UIView {
    
    // 设置layer.mask 这样做会有离屏渲染 帧率偏低，卡顿明显
    func clipWithMaskPath(radius: CGFloat, roundingCorners: UIRectCorner = .allCorners) {
        let rect = CGRect(origin: CGPoint.zero, size: self.frame.size)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        let shapLayer = CAShapeLayer()
        shapLayer.path = path.cgPath
        self.layer.mask = shapLayer
    }
    
    // 异步切割法
    func clipAsync(radius: CGFloat, roundingCorners: UIRectCorner = .allCorners) {
        let rect = CGRect(origin: CGPoint.zero, size: self.frame.size)
        DispatchQueue.global().async {
            let imageView: UIImageView
            if let aImageView = self.viewWithTag(999111222) as? UIImageView {
                imageView = aImageView
            } else {
                imageView = UIImageView(frame: rect)
                imageView.tag = 999111222
                DispatchQueue.main.async(execute: {
                    self.addSubview(imageView)
                })
            }
            imageView.isUserInteractionEnabled = false
            imageView.isOpaque = true
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            let bgLayer = CALayer()
            bgLayer.backgroundColor = self.backgroundColor?.cgColor
            bgLayer.frame = self.bounds
            bgLayer.render(in: context)
            
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            path.addClip()
            
            self.layer.render(in: context)
            
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async(execute: {
                imageView.image = outputImage
            })
        }
    }
    
    // 粘贴圆角法
    @objc func drawRoundedCorner(image: UIImage? = nil, radius: CGFloat, roundingCorners: UIRectCorner = .allCorners, fillColor: UIColor) {
        let subImage = UIGraphicsDrawAntiRoundedCornerImage(radius: radius, size: self.frame.size, fillColor: fillColor)
        if let aImageView = self.viewWithTag(999111223) as? UIImageView {
            aImageView.image = subImage
        } else {
            let imageView = UIImageView(image: subImage)
            imageView.tag = 999111223
            addSubview(imageView)
        }
    }
    
}

func UIGraphicsDrawAntiRoundedCornerImage(radius: CGFloat, size: CGSize, fillColor: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    let currentContext = UIGraphicsGetCurrentContext()
    let bezierPath = UIBezierPath()
    
    let hLeftUpPoint = CGPoint(x: radius, y: 0)
    let hRightUpPoint = CGPoint(x: size.width - radius, y: 0)
    let hLeftDownPoint = CGPoint(x: radius, y: size.height)
    
    let vLeftUpPoint = CGPoint(x: 0, y: radius)
    let vRightDownPoint = CGPoint(x: size.width, y: size.height - radius)
    
    let centerLeftUp = CGPoint(x: radius, y: radius)
    let centerRightUp = CGPoint(x: size.width - radius, y: radius)
    let centerLeftDown = CGPoint(x: radius, y: size.height - radius)
    let centerRightDown = CGPoint(x: size.width - radius, y: size.height - radius)
    
    bezierPath.move(to: hLeftUpPoint)
    bezierPath.addLine(to: hRightUpPoint)
    bezierPath.addArc(withCenter: centerRightUp, radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true)
    bezierPath.addLine(to: vRightDownPoint)
    bezierPath.addArc(withCenter: centerRightDown, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
    bezierPath.addLine(to: hLeftDownPoint)
    bezierPath.addArc(withCenter: centerLeftDown, radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
    bezierPath.addLine(to: vLeftUpPoint)
    bezierPath.addArc(withCenter: centerLeftUp, radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 3 / 2), clockwise: true)
    bezierPath.close()
    
    //If draw drection of outer path is same with inner path, final result is just outer path.
    bezierPath.move(to: CGPoint.zero)
    bezierPath.addLine(to: CGPoint(x: 0, y: size.height))
    bezierPath.addLine(to: CGPoint(x: size.width, y: size.height))
    bezierPath.addLine(to: CGPoint(x: size.width, y: 0))
     //bezierPath.addLine(to: CGPoint.zero)
    bezierPath.close()
    
    fillColor.setFill()
    bezierPath.fill() // 显示路径
    
    currentContext!.drawPath(using: .fillStroke)
    let antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return antiRoundedCornerImage!
}


