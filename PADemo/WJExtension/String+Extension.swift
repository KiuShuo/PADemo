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
        return substring(to: index(startIndex, offsetBy: Int(charIndex)))
    }
    
    public func substring(from charIndex: UInt) -> String {
        return substring(from: index(startIndex, offsetBy: Int(charIndex)))
    }
    
    public func substring(in range: Range<UInt>) -> String {
        if Int(range.upperBound) > characters.count { return self }
        return substring(with: index(startIndex, offsetBy: Int(range.lowerBound))..<index(startIndex, offsetBy: Int(range.upperBound)))
    }
    
}

// MARK: - String + Attribute
public extension String {
    
    /// 宽度确定 计算高度 注：字符串中含有'\n'换行符等影响高度计算的内容时，需要特殊处理
    public func height(font: UIFont, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        let attributes = [NSFontAttributeName: font]
        return self.height(attributes: attributes, width: width)
    }
    
    public func height(attributes: [String: Any]?, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size, options: [.usesFontLeading], attributes: attributes, context: nil)
        return rect.height
    }
    
    /// 高度确定 计算宽度
    public func width(font: UIFont, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        let attributes = [NSFontAttributeName: font]
        return self.width(attributes: attributes, height: height)
    }
    
    public func width(attributes: [String: Any]?, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let rect = self.boundingRect(with: size, options: [.usesFontLeading], attributes: attributes, context: nil)
        return rect.width
    }
    
}

// MARK: - String + Date
public extension String {
    
    /// 用相对于1970年的秒数来创建一个日期字符串, 默认的formate是"YYYY.MM.dd"
    public init(dateFormat: String = "YYYY.MM.dd", secondsSince1970: Int) {
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = dateFormat
        let date = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
        self = dateFormatter.string(from: date)
    }
    
    public func date(dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
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
        let rect = CGRect.init(x: 0, y: 0, width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        image.draw(in: rect)
        
        let avatarSize = CGSize.init(width: logoWidth, height: logoWidth)
        logo.draw(in: CGRect.init(origin: CGPoint.init(x: (rect.width-logoWidth)*0.5, y: (rect.height-logoWidth)*0.5), size: avatarSize))
        
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
        let transformImage = colorFilter!.outputImage!.applying(transform)
        
        return transformImage
    }
    
}
