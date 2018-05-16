//
//  CTView.swift
//  ZZCoreTextDemo
//
//  Created by duzhe on 16/1/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CTView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1
        let context = UIGraphicsGetCurrentContext()
        
        // 2
        context?.textMatrix = CGAffineTransform.identity
        context?.translateBy(x: 0, y: self.bounds.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 3
        let path = CGMutablePath()
        
        let path1 = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.bounds.size.width/2)
        
        path.addRect(self.bounds)
        
        // 4
        let attrString = "Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!"
        
        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        mutableAttrStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor:UIColor.red], range: NSMakeRange(0, 20))
        mutableAttrStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13),NSAttributedStringKey.underlineStyle: 1 ], range: NSMakeRange(20,18))
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path1.cgPath, nil)
        
        // 5
        CTFrameDraw(frame,context!)
    }
    
}
