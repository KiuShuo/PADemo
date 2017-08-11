//
//  UIColor+Extension.swift
//  wanjia
//
//  Created by 周炳宇 on 16/4/12.
//  Copyright © 2016年 pingan. All rights reserved.
//

import UIKit
import HexColors

extension UIColor {
    /**
     创建颜色
     - parameter R: 红
     - parameter G: 绿
     - parameter B: 蓝
     - parameter A: 透明度
     */
    
    convenience init(R: Int, G: Int, B: Int, A: Float = 1.0) {
        self.init(red:   CGFloat(Float(R) / 255.0),
                  green: CGFloat(Float(G) / 255.0),
                  blue:  CGFloat(Float(B) / 255.0),
                  alpha: CGFloat(A))
    }
    
    convenience init(withRGBValue rgbValue: Int, alpha: Float = 1.0) {
        let r = ((rgbValue & 0xFF0000) >> 16)
        let g = ((rgbValue & 0x00FF00) >> 8)
        let b =  (rgbValue & 0x0000FF)
        self.init(R: r,
                  G: g,
                  B: b,
                  A: alpha)
    }
    
    class var paOrange: UIColor {
        return UIColor.init(withRGBValue: 0xFF6602)
    }
    
    class var paLightOrange: UIColor {
        return UIColor.init(withRGBValue: 0xFAE5D8)
    }
    
    class var paHighOrange: UIColor {
        return UIColor.init(withRGBValue: 0xF6B662)
    }
    
    // controller 页面背景颜色
    class var paBackground: UIColor {
        return UIColor.init(withRGBValue: 0xF8F8F8)
    }
    
    // 考勤打卡遮板
    class var paSignBackground: UIColor {
        return UIColor.init(withRGBValue: 0xFDF8F5)
    }
    
    // cell 默认白色
    class var paBackground2: UIColor {
        return UIColor.init(withRGBValue: 0xFFFFFF)
    }
    
    class var paLightWhite: UIColor {
        return UIColor.init(withRGBValue: 0xF0F0F0)
    }
    
    class var paBackground3: UIColor {
        return UIColor.init(withRGBValue: 0xBDBDBD)
    }
    
    // 分割线颜色 边框颜色  标签底色
    class var paDividing: UIColor {
        return UIColor.init(withRGBValue: 0xDFDFDF)
    }
    
    // 灰色 较弱文字信息 副标题 引导词
    class var paGray: UIColor {
        return UIColor.init(withRGBValue: 0x949494)
    }
    
    // 浅灰 背景色 板块底色
    class var paLightGray: UIColor {
        return UIColor.init(withRGBValue: 0xF4F4F4)
    }
    
    class var paLightGray2: UIColor {
        return UIColor.init(withRGBValue: 0xE4E4E4)
    }
    
    // 黑色
    class var paBlack: UIColor {
        return UIColor.init(withRGBValue: 0x353535)
    }
    
    class var paDeepBlack: UIColor {
        return UIColor.init(withRGBValue: 0x000000)
    }
    
    class var paLightBlack: UIColor {
        return UIColor.init(withRGBValue: 0x999999)
    }
    
    class var paFontBlack: UIColor {
        return UIColor.init(withRGBValue: 0x333333)
    }
    
    class var paFieldBackgroud: UIColor {
        return UIColor.init(withRGBValue: 0xF6F6F6)
    }
    
    // 绿色
    class var paGreen: UIColor {
        return UIColor.init(withRGBValue: 0x73D7AC)
    }
    
    class var paCCC: UIColor {
        return UIColor.init(withRGBValue: 0xCCCCCC)
    }
    
    class var paBlue: UIColor {
        return UIColor.init(withRGBValue: 0x3F96EB)
    }
    
    class var paButtonBackground: UIColor {
        return UIColor.init(withRGBValue: 0xFCF2EB)
    }
    
    // 按钮点击高亮背景颜色
    class var paButtonHighlightedBackground: UIColor {
        return UIColor.init(withRGBValue: 0xECECEC)
    }
    
    class var paLightGray3: UIColor {
        return UIColor.init(withRGBValue: 0xDDDDDD)
    }
    
}
