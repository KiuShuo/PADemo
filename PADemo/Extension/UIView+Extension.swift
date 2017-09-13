//
//  UIView+Extension.swift
//  wanjia2B
//
//  Created by 李井生 on 17/5/31.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

extension UIView {
    
    //圆角半径
    func setRadius(radius:CGFloat){
        if radius <= 0{
          self.layer.cornerRadius = self.frame.size.height*0.5
        }else{
          self.layer.cornerRadius = radius
        }
        self.layer.masksToBounds = true
    }
    
    /**
     *  在View上面增加分割线，分割线左边和右边都顶格，不留空隙
     */
    func addTopLineView(){
       addTopLineViewWithRect(rect: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.separatorSize))
    }
    /**
     *  在View上面增加分割线，可以通过rect自定义分割线frame
     */
    func addTopLineViewWithRect(rect:CGRect){
       addLineView(rect: rect, tag: 10000)
    }
    /**
     *  在View下面增加分割线，分割线左边和右边都顶格，不留空隙
     */
    func addBottomLineView(){
        addBottomLineViewWithRect(rect: CGRect(x: 0, y: self.frame.size.height-UIScreen.separatorSize, width: UIScreen.width, height: UIScreen.separatorSize))
    }
    /**
     *  在View下面增加分割线，可以通过rect自定义分割线frame
     */
    func addBottomLineViewWithRect(rect:CGRect){
        addLineView(rect: rect, tag: 10001)
    }
    /**
     *  移除View的分割线
     */
    func removeTopLineView(){
        let lineView : UIView? = self.viewWithTag(10000)
        if lineView != nil{
            lineView?.removeFromSuperview()
        }
    }
    func removeBottomLineView(){
        let lineView : UIView? = self.viewWithTag(10001)
        if lineView != nil{
            lineView?.removeFromSuperview()
        }
    }
    
    /**
     *  增加其他位置的分割线，比如竖的分割线
     *
     *  @param rect 分割线frame
     *  @param tag  分割线tag
     */
    func addLineView(rect:CGRect,tag:Int){
       
        var lineView : UIView? = self.viewWithTag(tag)
        if lineView != nil{
            lineView?.removeFromSuperview()
        }
        
        lineView = UILabel(frame: rect)
        lineView?.backgroundColor = UIColor.paDividing
        lineView?.tag = tag
        
        self.addSubview(lineView!)
    }
}
