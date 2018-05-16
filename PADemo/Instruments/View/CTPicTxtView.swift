//
//  CTPicTxtView.swift
//  ZZCoreTextDemo
//  图文混排 demo
//  Created by duzhe on 16/1/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CTPicTxtView: UIView {

    var image:UIImage?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1 获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 2 转换坐
        context?.textMatrix = CGAffineTransform.identity
        context?.translateBy(x: 0, y: self.bounds.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 3 绘制区域
        let path = UIBezierPath(rect: rect)
        
        // 4 创建需要绘制的文字
        let attrString = "Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!"
        
        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        
        mutableAttrStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20),
            NSAttributedStringKey.foregroundColor:UIColor.red], range: NSMakeRange(0, 5))
        mutableAttrStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13),NSAttributedStringKey.underlineStyle: 1 ], range: NSMakeRange(3,10))
        let style = NSMutableParagraphStyle()   //用来设置段落样式
        style.lineSpacing = 6 //行间距
        mutableAttrStr.addAttributes([NSAttributedStringKey.paragraphStyle:style], range: NSMakeRange(0, mutableAttrStr.length))
        
        // 5 为图片设置CTRunDelegate,delegate决定留给图片的空间大小
        var imageName = "mc"
        var  imageCallback =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
            
            }, getAscent: { ( refCon) -> CGFloat in
                
//                let imageName = "mc"
//                refCon.initialize()
//                let image = UIImage(named: imageName)
                return 100  //返回高度
                
            }, getDescent: { (refCon) -> CGFloat in
                
                return 50  //返回底部距离
                
            }) { (refCon) -> CGFloat in
                
//                let imageName = String("mc")
//                let image = UIImage(named: imageName)
                return 100  //返回宽度
                
        }
        let runDelegate  = CTRunDelegateCreate(&imageCallback, &imageName)
        let imgString = NSMutableAttributedString(string: " ")  // 空格用于给图片留位置
        
        imgString.addAttribute(NSAttributedStringKey(rawValue: String(kCTRunDelegateAttributeName)), value: runDelegate!, range: NSMakeRange(0, 1))  //rundelegate  占一个位置
        imgString.addAttribute(NSAttributedStringKey(rawValue: "imageName"), value: imageName, range: NSMakeRange(0, 1))//添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgString, at: 15)
        
        
        //网络图片相关
        var  imageCallback1 =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
            
            }, getAscent: { ( refCon) -> CGFloat in
                return 70  //返回高度
                
            }, getDescent: { (refCon) -> CGFloat in
                
                return 50  //返回底部距离
                
            }) { (refCon) -> CGFloat in
                return 100  //返回宽度
                
        }
        var imageUrl = "http://img3.3lian.com/2013/c2/64/d/65.jpg" //网络图片链接
        let urlRunDelegate  = CTRunDelegateCreate(&imageCallback1, &imageUrl)
        let imgUrlString = NSMutableAttributedString(string: " ")  // 空格用于给图片留位置
        imgUrlString.addAttribute(NSAttributedStringKey(rawValue: String(kCTRunDelegateAttributeName)), value: urlRunDelegate!, range: NSMakeRange(0, 1))  //rundelegate  占一个位置
        imgUrlString.addAttribute(NSAttributedStringKey(rawValue: "urlImageName"), value: imageUrl, range: NSMakeRange(0, 1))//添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgUrlString, at: 50)
        
        
        // 6 生成framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path.cgPath, nil)
        
        // 7 绘制除图片以外的部分
        CTFrameDraw(frame,context!)
        
        // 8 处理绘制图片逻辑
        let lines = CTFrameGetLines(frame) as NSArray //存取frame中的ctlines
        

        let ctLinesArray = lines as Array
        var originsArray = [CGPoint](repeating: CGPoint.zero, count:ctLinesArray.count)
        let range: CFRange = CFRangeMake(0, 0)
        CTFrameGetLineOrigins(frame,range,&originsArray)
        
        //遍历CTRun找出图片所在的CTRun并进行绘制,每一行可能有多个
        for i in 0..<lines.count{
            //遍历每一行CTLine
            let line = lines[i]
            var lineAscent = CGFloat()
            var lineDescent = CGFloat()
            var lineLeading = CGFloat()
            //该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
            CTLineGetTypographicBounds(line as! CTLine, &lineAscent, &lineDescent, &lineLeading)
            
            let runs = CTLineGetGlyphRuns(line as! CTLine) as NSArray
            for j in 0..<runs.count{
                // 遍历每一个CTRun
                var  runAscent = CGFloat()
                var  runDescent = CGFloat()
                let  lineOrigin = originsArray[i]// 获取该行的初始坐标
                let run = runs[j] // 获取当前的CTRun
                let attributes = CTRunGetAttributes(run as! CTRun) as NSDictionary
            
                let width =  CGFloat( CTRunGetTypographicBounds(run as! CTRun, CFRangeMake(0,0), &runAscent, &runDescent, nil))
                
                let  runRect = CGRect(x: lineOrigin.x + CTLineGetOffsetForStringIndex(line as! CTLine, CTRunGetStringRange(run as! CTRun).location, nil), y: lineOrigin.y - runDescent, width: width, height: runAscent + runDescent)
                let imageNames = attributes.object(forKey: "imageName")
                let urlImageName = attributes.object(forKey: "urlImageName")
                
                if imageNames is NSString {
                    //本地图片
                    let image = UIImage(named: imageName as String)
                    let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y-runDescent, width: 100, height: 100)
                    if let cgImage = image?.cgImage {
                        context?.draw(cgImage, in: imageDrawRect)
                    }
                }
                
                if let urlImageName = urlImageName as? String{
                    var image:UIImage?
                    let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y-runDescent, width: 100, height: 100)
                    if self.image == nil{
                        image = UIImage(named:"hs") //灰色图片占位
                        //去下载
                        if let url = URL(string: urlImageName){
                            let request = NSURLRequest(url: url)
                            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, resp, err) -> Void in
                                if let data = data{
                                    DispatchQueue.main.sync {
                                        self.image = UIImage(data: data)
                                        self.setNeedsDisplay()  //下载完成会重绘
                                    }
                                }
                            }).resume()
                        }

                    }else{
                        image = self.image
                    }
                    if let cgImage = image?.cgImage {
                        context?.draw(cgImage, in: imageDrawRect)
                    }
                }
            }
        }
        
    }
    
}

