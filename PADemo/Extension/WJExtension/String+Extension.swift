//
//  String+Extebsions.swift
//  WJExtension
//
//  Created by 靳朋 on 2017/5/25.
//  Copyright © 2017年 wanjia. All rights reserved.
//

import Foundation
import UIKit

// MARK: - String + Basic
public extension String {
    
    public func substring(to charIndex: UInt) -> String {
        let toIndex = index(startIndex, offsetBy: Int(charIndex))
        return String(self[...toIndex])
    }
    
    public func substring(from charIndex: UInt) -> String {
        let fromIndex = index(startIndex, offsetBy: Int(charIndex))
        return String(self[fromIndex...])
    }
    
    public func substring(in range: Range<UInt>) -> String {
        if Int(range.upperBound) > count { return self }
        let fromIndex = index(startIndex, offsetBy: Int(range.lowerBound))
        let toIndex = index(startIndex, offsetBy: Int(range.upperBound))
        return String(self[fromIndex..<toIndex])
    }
    
}

// MARK: - String + Transform
public extension String {
    
    var floatValue: Float {
        if let value = Float(self) {
            return value
        }
        return 0
    }
    
    var intValue: Int {
        if let value = Int(self) {
            return value
        }
        return 0
    }
    
    var doubleValue: Double {
        if let value = Double(self) {
            return value
        }
        return 0
    }
    
   
    
}

// MARK: - String + Size
/**
 !!! 需要注意的点：
 
 1. 字符串的宽高并不能代表盛放其的容器视图的宽高，如果需要计算UIlabel、UITextView等视图的宽高，请使用UIView自带的计算Size的函数:
 func sizeThatFits(_ size: CGSize) -> CGSize
 
 2. 宽度确定 计算高度 注：字符串中含有'\n'换行符等影响高度计算的内容时，需要特殊处理。
*/
public extension String {

    public func height(width: CGFloat = CGFloat.greatestFiniteMagnitude, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return height(width: width, attributes: attributes)
    }
    
    public func height(width: CGFloat = CGFloat.greatestFiniteMagnitude, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        if isEmpty || width == 0 {
            return 0
        }
        var attributeArr = attributes
        if let paragraphStyle = attributeArr[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
            if paragraphStyle.lineBreakMode != .byWordWrapping && paragraphStyle.lineBreakMode != .byCharWrapping {
                paragraphStyle.lineBreakMode = .byWordWrapping
            }
            attributeArr[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }

        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attributeArr, context: nil)
        return rect.height
    }
    
    public func width(height: CGFloat = CGFloat.greatestFiniteMagnitude, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return width(height: height, attributes: attributes)
    }
    
    public func width(height: CGFloat = CGFloat.greatestFiniteMagnitude, attributes: [NSAttributedString.Key: Any]?) -> CGFloat {
        if isEmpty || height == 0 {
            return 0
        }
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        return rect.width
    }
    
}

// MARK: - String + Date
public extension String {
    
    /// 用相对于1970年的秒数来创建一个日期字符串, 默认的formate是"YYYY.MM.dd"
    public init(dateFormat: String = "yyyy.MM.dd", secondsSince1970: Int64) {
        let dateFormatter = DateFormatter.cache(formate: dateFormat)
        let date = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
        self = dateFormatter.string(from: date)
    }
    
    public func date(dateFormat: String = "yyyy-MM-dd") -> Date? {
        return DateFormatter.cache(formate: dateFormat).date(from: self)
    }
    
    /// date 字符串格式转换
    public func dateFormatConvert(form: String = "yyyy-MM-dd", to:String = "yyyy年MM月dd日") -> String {
        if let date = self.date(dateFormat: form){
            return date.toString(by: to)
        }
        return ""
    }
    
}

// MARK: - String + QRCode
public extension String {
    
    /// 生成黑白普通二维码(默认大小为300)
    public func generatorQRCode(size: CGFloat = 300) -> UIImage {
        let ciImage = generateCIImage(size: size, color: UIColor.black, bgColor: UIColor.white)
        return UIImage(ciImage: ciImage)
    }
    
    public func generatorQRCode(size: CGFloat = 300, logo: UIImage, logoSize: CGFloat?) -> UIImage {
        let ciImage = generateCIImage(size: size, color: UIColor.black, bgColor: UIColor.white)
        let image = UIImage(ciImage: ciImage)
        let logoWidth:CGFloat = logoSize ?? logo.size.width
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        image.draw(in: rect)
        
        let avatarSize = CGSize(width: logoWidth, height: logoWidth)
        logo.draw(in: CGRect(origin: CGPoint(x: (rect.width-logoWidth) * 0.5, y: (rect.height - logoWidth) * 0.5), size: avatarSize))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
    
    /**
     7.生成CIImage
     
     - parameter size:    大小 //默认300
     - parameter color:   颜色 默认黑色二维码
     - parameter bgColor: 背景颜色 默认白色背景
     
     - returns: CIImage
     */
    public func generateCIImage(size: CGFloat, color: UIColor, bgColor: UIColor) -> CIImage {
        //二维码滤镜
        let contentData = self.data(using: String.Encoding.utf8)
        let fileter = CIFilter(name: "CIQRCodeGenerator")
        
        fileter?.setValue(contentData, forKey: "inputMessage")
        fileter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let ciImage = fileter?.outputImage
        
        //颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(cgColor: color.cgColor), forKey: "inputColor0")// 二维码颜色
        colorFilter?.setValue(CIColor(cgColor: bgColor.cgColor), forKey: "inputColor1")// 背景色
        
        //生成处理
        let outImage = colorFilter!.outputImage
        let scale = size / outImage!.extent.size.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = colorFilter!.outputImage!.transformed(by: transform)
        
        return transformImage
    }
    
}

