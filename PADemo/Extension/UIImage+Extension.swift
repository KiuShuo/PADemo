//
//  UIImage+Extension.swift
//  feng
//
//  Created by luozhijun on 2016/10/26.
//  Copyright © 2016年 shuo. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImage {
    /// 用颜色创建一张图片
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// 返回一张有圆角的图片
    func roundingCorner(forRadius radius: CGFloat, atCorners corners: UIRectCorner = .allCorners, contentMode: UIView.ContentMode = .scaleAspectFill, sizeToFit: CGSize = .zero) -> UIImage? {
        var usingSize = sizeToFit
        if usingSize == .zero {
            usingSize = self.size
        }
        let boundingRect = CGRect(x: 0, y: 0, width: usingSize.width, height: usingSize.height)
        let tempImageView = UIImageView(image: self)
        tempImageView.bounds = boundingRect
        return tempImageView.roundingImage(forRadius: radius, atCorners: corners, contentMode: contentMode, sizeToFit: sizeToFit)
    }
    
    /// 返回一张可拉伸的图片, 参数分别是图片宽度的一半和图片高度的一半
    var stretchable: UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width/2.0), topCapHeight: Int(self.size.height/2.0))
    }
    
    /// 便利方法, 返回常用按钮所需的两张图片, 第一张是normal状态的, 第二张是highlighted状态的
    static var buttonBackgroundImage: (bgImage: UIImage?, highlightBgImage: UIImage?) {
        let bgImage   = UIImage(color: UIColor.paOrange, size: CGSize(width: 10, height: 10))?.roundingCorner(forRadius: 3)?.stretchable
        let hlBgImage = UIImage(color: UIColor.paHighOrange, size: CGSize(width: 10, height: 10))?.roundingCorner(forRadius: 3)?.stretchable
        return (bgImage, hlBgImage)
    }
    
    /// 防止头像旋转
    func fixRevolve() -> UIImage{
        if self.imageOrientation == .up{
            return self
        }
        
        var transform:CGAffineTransform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored,.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                      bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: self.cgImage!.colorSpace!,
                                      bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch self.imageOrientation {
        case .leftMirrored,.left,.rightMirrored,.right:
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        return img
        
    }
    
    func watermarkImage(_ text:String) ->UIImage? {
        let newImageName = "/Documents/\(text)cacheImage@3x.png"
        let pngPath = NSHomeDirectory()+newImageName
        if let img = UIImage.init(contentsOfFile: pngPath) {
            return img
        }
        
        if (UIDevice.current.systemVersion as NSString).floatValue >= 4.0{
            UIGraphicsBeginImageContextWithOptions(self.size, false, 3.0)
        }else {
            UIGraphicsBeginImageContext(self.size);
        }
        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let height:CGFloat = text.height(font: UIFont.systemFont(ofSize: 12))
        let rect = CGRect.init(x: 0, y: (self.size.height-height)*0.5, width: self.size.width, height: height)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        (text as NSString).draw(in: rect , withAttributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),NSAttributedString.Key.paragraphStyle:style,NSAttributedString.Key.foregroundColor:UIColor.white])
        
        
        if let watermarkImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            if let data = watermarkImage.pngData() as NSData? {
                data.write(toFile: pngPath, atomically: true)
                
                return watermarkImage
            }
            
        }
        
        return nil
    }
    
    // 使用URLString获取一张图片
//    @discardableResult
//    class func getImageWithURLString(_ urlString: String, showLoadingView: Bool = false, completion: @escaping (_ image: UIImage?) -> ()) -> SDWebImageOperation? {
//        if let url = URL.init(string: urlString) {
//            if SDWebImageManager.shared().cachedImageExists(for: url) {
//                let key = SDWebImageManager.shared().cacheKey(for: url)
//                let image = SDImageCache.shared().imageFromDiskCache(forKey:key)
//                completion(image)
//                return nil
//            } else if SDWebImageManager.shared().diskImageExists(for: url){
//                let key = SDWebImageManager.shared().cacheKey(for: url)
//                let image = SDImageCache.shared().imageFromDiskCache(forKey: key)
//                completion(image)
//                return nil
//            } else {
//                if showLoadingView {
//                    PAMBManager.sharedInstance.showLoading(view: nil)
//                }
//                let operation =
//                    SDWebImageManager.shared().downloadImage(
//                        with: url,
//                        options: SDWebImageOptions.init(rawValue: 0),
//                        progress: nil,
//                        completed: { [showLoadingView, completion] (image, error, cacheType, finished, imageURL) in
//                            if showLoadingView {
//                                PAMBManager.sharedInstance.hideAlert(view: nil)
//                            }
//                            completion(image)
//                        }
//                )
//                return operation
//            }
//        } else {
//            completion(nil)
//            return nil
//        }
//    }
}

