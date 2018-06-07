//
//  CTViewController.swift
//  PADemo
//
//  Created by shuo on 2018/5/16.
//  Copyright © 2018年 shuo. All rights reserved.
//

/*
 参考资料：
 
 [Swift之CoreText排版神器(长篇高能)](https://www.jianshu.com/p/e52a38e60e7c)
 [基于 CoreText 的排版引擎：基础](https://blog.devtang.com/2015/06/27/using-coretext-1/)
 
 */

import UIKit

class CTViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        textView()
    }
    
    func textView() {
        //        NSAttributedString
        //        NSMutableAttributedString
        
        //        let str = "这是一段用来测试的字符串 this is a string for test"
        //        let dic = [NSAttributedStringKey.font:UIFont.boldSystemFontOfSize(20),
        //            NSAttributedStringKey.foregroundColor:UIColor.redColor()]
        ////        let attrStr = NSAttributedString(string: str, attributes: dic)
        ////        label.attributedText = attrStr
        ////        label.textColor = UIColor.yellowColor()
        //
        //        let mutableAttrStr = NSMutableAttributedString(string: str)
        //        mutableAttrStr.addAttributes(dic, range: NSMakeRange(0, 2))
        //        mutableAttrStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFontOfSize(13),NSAttributedStringKey.underlineStyle: 1 ], range: NSMakeRange(2,8))
        //        label.attributedText = mutableAttrStr
        
        
        //        let ctView = CTView()
        //        ctView.frame = CGRectMake(10, 150, self.view.bounds.width - 20, 200)
        //        ctView.backgroundColor = UIColor.whiteColor()
        //        self.view.addSubview(ctView)
        
        //        let cptView = CTPicTxtView()
        //        cptView.frame = CGRectMake(10, 100, self.view.bounds.width - 20, 600)
        //        cptView.backgroundColor = UIColor.whiteColor()
        //        self.view.addSubview(cptView)
        
        
        //        let font = UIFont.systemFontOfSize(14)
        //        print(font.descender)       //-3.376953125
        //        print(font.ascender)        //13.330078125
        //        print(font.lineHeight)      //16.70703125
        //        print(font.capHeight)       //9.8642578125
        //        print(font.xHeight)         //7.369140625
        //        print(font.leading)         //0.0
        
        let ctextView = CTextView()
        ctextView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 200)
        ctextView.backgroundColor = UIColor.green
        view.addSubview(ctextView)
        
        let displayView = DisplayView(frame: CGRect(x: 10, y: 310, width: self.view.bounds.width - 20, height: 200))
        displayView.backgroundColor = UIColor.green
        view.addSubview(displayView)
        
        //        let ctURLView = CTURLView()
        //        ctURLView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 300)
        //        ctURLView.backgroundColor = UIColor.gray
        //        let mutableAttrStr = NSMutableAttributedString(string: ctURLView.str)
        //        let size = ctURLView.sizeForText(mutableAttrStr: mutableAttrStr)
        //        ctURLView.frame.size = size
        //        self.view.addSubview(ctURLView)
    }

}
