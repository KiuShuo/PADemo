//
//  UIButton+Extension.swift
//  feng
//
//  Created by lichao_liu on 16/8/15.
//  Copyright © 2016年 shuo. All rights reserved.
//

import UIKit

extension UIButton {
    
    class  func orangeBorderBtn(_ title:String,fontSize:CGFloat) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.paOrange, for: UIControlState())
        btn.setTitle(title, for: UIControlState())
        btn.setTitleColor(UIColor.paDeepBlack, for: .highlighted)
        btn.layer.borderColor = UIColor.paOrange.cgColor
        btn.layer.borderWidth = 1
        return btn
    }
    
    class func orangeBtn(_ title:String,fontSize:CGFloat) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.paBackground2, for: UIControlState())
        btn.setTitleColor(UIColor.paBlack, for: .highlighted)
        btn.setBackgroundImage(UIImage(color: UIColor.paOrange), for: .normal)
        btn.setBackgroundImage(UIImage(color: UIColor.paLightOrange), for: .highlighted)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
        return btn
    }
    
    class func lightOrangeBtn(_ title:String,fontSize:CGFloat)-> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.paBlack, for: UIControlState())
        btn.setTitleColor(UIColor.paBackground2, for: .highlighted)
        btn.setBackgroundImage(UIImage(color: UIColor.paLightOrange), for: .normal)
        btn.setBackgroundImage(UIImage(color: UIColor.paOrange), for: .highlighted)
        btn.setBackgroundImage(UIImage(color: UIColor.paOrange), for: .selected)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
        return btn
    }
    
    class func lightBlackBtn(_ title:String,fontSize:CGFloat)-> UIButton {
        let btn = UIButton.init(type: .custom)
        let width:CGFloat = max(CGFloat(title.count),3.0) * fontSize + 8.0
        btn.frame = CGRect(x: 0, y: 0, width: width, height: 22)
        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.paBlack, for: UIControlState())
        btn.setTitleColor(UIColor.paBackground2, for: .highlighted)
        btn.setBackgroundImage(UIImage(color: UIColor.paLightGray2), for: .normal)
        btn.setBackgroundImage(UIImage(color: UIColor.paOrange), for: .highlighted)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
        return btn
    }
    
    class func createNoBackgroundOrangeBtn(_ title:String,fontSize:CGFloat,normalColor:UIColor = UIColor.paOrange,highlightedColor:UIColor = UIColor.paHighOrange)->UIButton {
        let btn = UIButton.init(type: .custom)
        let width:CGFloat = CGFloat(title.count) * fontSize + 8.0
        btn.frame = CGRect(x: 0, y: 0, width: width, height: 22)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(highlightedColor, for: .highlighted)
        return btn
    }
    
    class func createBtnWithImage(_ nomalImageName:String,highImageName:String?)->UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setBackgroundImage(UIImage(named: nomalImageName), for: UIControlState())
        if let highImageName = highImageName {
            btn.setBackgroundImage(UIImage(named: highImageName), for: .highlighted)
        }
        return btn
    }
    
    class func orangeBtn2(_ title:String,fontSize:CGFloat) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.paBackground2, for: UIControlState())
        btn.setTitleColor(UIColor.paBackground2, for: .highlighted)
        btn.setTitleColor(UIColor.white, for: .highlighted)
        btn.setBackgroundImage(UIImage(color: UIColor.paHighOrange), for: .highlighted)
        btn.setBackgroundImage(UIImage(color: UIColor.paOrange), for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
        return btn
    }
    
    class func createBtn(_ title:String,fontSize:CGFloat,normalColor:UIColor?,selectedColor:UIColor?,corners:CGFloat = 0,normalBackgroundColor:UIColor?,selectedBackgroundColor:UIColor?,highlightedColor:UIColor = UIColor.paBackground2,highlightedBackgroundColor:UIColor = UIColor.paOrange)->UIButton {
        let btn = UIButton()
        if corners > 0{
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = corners
        }
        if let normalBackColor = normalBackgroundColor {
            btn.setBackgroundImage(UIImage(color: normalBackColor), for: .normal)
        }
        if let selectedBackColor = selectedBackgroundColor {
            btn.setBackgroundImage(UIImage(color: selectedBackColor), for: .selected)
        }
        btn.setBackgroundImage(UIImage(color: highlightedBackgroundColor), for: .highlighted)
        btn.setBackgroundImage(UIImage(color: highlightedBackgroundColor), for:[.highlighted,.selected])

        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(normalColor, for: UIControlState())
        btn.setTitleColor(selectedColor, for: .selected)
        btn.setTitleColor(highlightedColor, for: .highlighted)
        btn.setTitleColor(highlightedColor, for: [.highlighted,.selected])

        return btn
    }
}
extension UIButton {
    //定制UIButton内的tittle和image的排版
    //以image的位置判断，分别为左右上下
    enum ImageDirection {
        case horizontalLeft,horizontalright,verticalTop,verticalBottom
    }
    // 注：若水平方向 tittle的宽度加上image的宽度加上间距不能超过UIButton的宽度，同理竖直方向也不能超过。
    // distance 为间距
    func createBtn(type:ImageDirection,title:String,font:CGFloat,image:UIImage,distance:CGFloat){
        self.setImage(image, for: .normal)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        let titleWidth = title.width(font: UIFont.systemFont(ofSize: font))
        let titleHeight = title.height(font: UIFont.systemFont(ofSize: font))
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        //UIEdgeInsetsMake 默认为(0, 0, 0, 0)，显示的是image在左边，title在右边
        //位置相对变化方向与UIEdgeInsetsMake相对应的方向位置的值负相关，相反方向位置的值正相关
        switch type {
        case .horizontalLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -distance/2, 0, distance/2)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, distance/2, 0, -distance/2)
        case .horizontalright:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+distance, 0, -(titleWidth+distance))
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth+distance), 0, imageWidth+distance)
        case .verticalTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleHeight+distance)/2, titleWidth/2, (titleHeight+distance)/2, -titleWidth/2)
            self.titleEdgeInsets = UIEdgeInsetsMake((imageHeight+distance)/2, -imageWidth/2, -(imageHeight+distance)/2, imageWidth/2)
        case .verticalBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake((titleHeight+distance)/2, titleWidth/2, -(titleHeight+distance)/2, -titleWidth/2)
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageHeight+distance)/2, -imageWidth/2, (imageHeight+distance)/2, imageWidth/2)
            
        }
        
        
    }
}
