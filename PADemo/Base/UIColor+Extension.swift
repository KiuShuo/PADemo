//
//  UIColor+Extension.swift
//  wanjia
//
//  Created by 周炳宇 on 16/4/12.
//  Copyright © 2016年 pingan. All rights reserved.
//

import UIKit
import HexColors

let EMPTY_CELL_COLOR = "#F8F8F8"
//黑色
let COLOR_000000 = "#000000"

//深红
let PAORANGE = "#FF6602"

//万家人才字体灰色
let COLOR_949494 = "#949494"

// 黑色(带点灰)字体黑
let COLOR_353535 = "#353535"

//白色
let COLOR_FFFFFF = "#FFFFFF"

extension UIColor {
    /**
    创建颜色
    
    - parameter R: 红
    - parameter G: 绿
    - parameter B: 蓝
    - parameter A: 透明度
    */
    class func colorWithRGBA(_ R: Float, G: Float, B: Float, A: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat(R / 255.0), green: CGFloat(G / 255.0), blue: CGFloat(B / 255.0), alpha: CGFloat(A))
    }
    
    class  func colorWithRGB(_ rgbValue:Int,alpha:CGFloat)->UIColor {
        return UIColor.init(red:CGFloat((rgbValue & 0xFF0000)>>16)/CGFloat(255.0),
                            green: ((CGFloat) (((rgbValue) & 0x00FF00) >> 8)) / 255.0,
                            blue: ((CGFloat) ((rgbValue) & 0x0000FF)) / 255.0,
                            alpha: alpha)
    }
    
    class func paOrangeColorStr()-> String {
        return PAORANGE
    }
    
    class func colorWithRGB(_ rgbValue:Int)->UIColor{
        return self.colorWithRGB(rgbValue, alpha: 1)
    }
    
    class func paOrangeColor()-> UIColor{
        return UIColor(hexString: paOrangeColorStr())
    }
    
    class func paLightOrangeColor()->UIColor {
        return UIColor(hexString: "#FAE5D8")
    }
    
    class func paHighOrangeColor()->UIColor {
        return UIColor(hexString: "#f6b662")
    }

    //controller 页面背景颜色
    class func paBackgroundColor()-> UIColor {
        return UIColor(hexString: "#F8F8F8")
    }
    //考勤打卡遮板
    class func paSignBackgroundColor()-> UIColor {
        return UIColor(hexString: "#FDF8F5")
    }
    
    //cell 默认白色
    class  func paBackgroundColor2()->UIColor {
        return UIColor(hexString: COLOR_FFFFFF)
    }
    
    class func paBackgroundColor2Str() -> String {
        return COLOR_FFFFFF
    }
    
    class func paLightWhiteColor() -> UIColor {
        return UIColor(hexString: "#F0F0F0")
    }
    
    //cell选中色
    class func paBackgroundColor3()->UIColor {
        return UIColor.colorWithRGB(0xBDBDBD)
    }
    
    //分割线颜色 边框颜色  标签底色
    class func paDividingColor()->UIColor {
        return UIColor(hexString: "#DFDFDF")
    }
    
    //灰色 较弱文字信息 副标题 引导词
    class func paGrayColor()->UIColor {
        return UIColor(hexString: COLOR_949494)
    }
    
    //浅灰 背景色 板块底色
    class func paLightGrayColor()->UIColor {
        return UIColor(hexString: "#f4f4f4")
    }
    
    class func paLightGrayColor2() -> UIColor {
        return UIColor(hexString: "#E4E4E4")
    }
    //黑色
    class func paBlackColor()->UIColor {
        return UIColor(hexString: COLOR_353535)
    }
    
    class func paDeepBlackColor() -> UIColor {
        return UIColor(hexString: COLOR_000000)
    }
    
    class func paLightBlackColor() -> UIColor {
        return UIColor(hexString: "#999999")
    }
    
    class func paFontBlackColor()->UIColor {
        return UIColor(hexString: "#333333")
    }
    
    class func paFieldBackgroudColor()->UIColor {
        return UIColor(hexString: "#f6f6f6")
    }
    
    class func paBtnBackgroundColor()->UIColor {
        return UIColor(hexString: "#fcf2eb")
    }
    
    //绿色
    class func paGreenColor()->UIColor {
        return UIColor(hexString: "#73d7ac")
    }
    
    class func paCCCCColor()->UIColor {
        return UIColor(hexString: "#CCCCCC")
    }
    
    class func paBlueColor()->UIColor {
        return UIColor(hexString: "#3F96EB")
    }
    
    // 按钮点击高亮背景颜色
    class func paButtonHighlightedBackgroundColor()->UIColor {
        return UIColor(hexString: "#ECECEC")
    }
    
    class func paLightGrayColor3()->UIColor {
        return UIColor(hexString: "#dddddd")
    }
    
}
