//
//  DetailViewController.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//  1.Calendar 用法
//

import UIKit
import SDWebImage
import WJExtension

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    static func makeViewController(viewControllerClass: BaseViewController.Type) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self))
    }
    // "现场查看是否有铅衣等防护用品，且可使用；比如齿科的全景X光机；无放射科则不适用\n（需有照片）"
    let text = "现场查看是否有铅衣等防护用品，且可使用；比如齿科的全景X光机；无放射科则不适用（需有照片）"
    let shortText = "现场查看是否有铅衣等"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageUrlStr = "https://cdn.pixabay.com/photo/2017/03/13/10/31/greylag-goose-2139296_640.jpg"
        _ = getImage(urlString: imageUrlStr)
//        if let imageUrl = URL(string: "https://cdn.pixabay.com/photo/2017/03/13/10/31/greylag-goose-2139296_640.jpg") {
//            let _ = SDWebImageDownloader.shared().downloadImage(with: imageUrl, options: .  useNSURLCache, progress: nil, completed: { (image, _, _, success) in
//                if success {
//                    self.imageView.image = image
//                }
//            })
//        }

        // label size
        //setupAutoHeightLabel()
        
        // Calendar
        // PADateHandel.learnCalendar()
        
        // range
        // PARange.learnRange()
        
        stringWidth()
        
        stringHeight()
        
    }
    
    func getImage(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            saveImage(image: image!)
            return image
        } catch let error {
            print("get image error = \(error)")
        }
        return nil
    }
    
    private func saveImage(image: UIImage) {
        
        let result = PAFileManager.fileManager.saveDataToSandbox(image, directory: "Documents", fileName: "Image.jpg", key: "123")
        print("\(result.0, result.1)")
        
        self.imageView.image = PAFileManager.fileManager.getDataFromSandbox("Image.jpg", directory: "Documents", key: "123")
    }

    
    // 根据文本计算label size
    func setupAutoHeightLabel() {
        let label = UILabel()
        view.addSubview(label)
        label.backgroundColor = UIColor.red
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24)
        let paHeight = PAStringHeightMakeWithText(text, 24, 0, PADeviceSize.screenWidth - 20)
        debugLog("paHeight = \(paHeight)")
        let height = label.sizeThatFits(CGSize(width: PADeviceSize.screenWidth - 20, height: CGFloat.greatestFiniteMagnitude)).height
        debugLog("height = \(height)")
        label.mas_makeConstraints { (make) in
            make!.top.equalTo()(74)
            make!.left.equalTo()(10)
            make!.right.equalTo()(-10)
            make!.height.equalTo()(height)
        }
    }

}

// MARK: - 字符串 Size
extension DetailViewController {
    
    func stringWidth() {
        let w = PAStringWidthMakeWithText(shortText, 15)
        debugLog("w = \(w)")
        
        let w1 = shortText.width(font: UIFont.systemFont(ofSize: 15))
        debugLog("w1 = \(w1)")
    }
    
    func stringHeight() {
        let h = PAStringHeightMakeWithText(shortText, 15, 0, UIScreen.width)
        debugLog("h = \(h)")
        
        let h1 = text.height(width: UIScreen.width, font: UIFont.systemFont(ofSize: 15)) + 5
        debugLog("h1 = \(h1)")
        
    }
    
    
}

// MARK: Range
struct PARange {
    // Range类似于集合 以下为Range的常用方法
    static func learnRange() {
        
        let range1 = 0...10
        debugLog("range1 = \(range1)")
        for e in range1 {
            debugLog("range1.e = \(e)")
        }
        
        let range2 = 0..<10
        debugLog("range2 = \(range2)")
        
        let arr = [1, 2, 3 ,4, 5, 6]
        let range = 1..<3
        // 表示获取从下标为1到下标为2的子数组
        debugLog("subString = \(arr[range])")
        
        let string = "abcdefg"
        let start = string.index(string.startIndex, offsetBy: 1)
        let end = string.index(string.startIndex, offsetBy: 4)
        let subRange: Range<String.Index> = start..<end // ！！！这里只能使用右半开区间 使用右闭区间报错 暂时不知道为什么
        debugLog("subRange = \(subRange)")
        let subString = string.substring(with: subRange)
        // 获取下标从1开始到下标为4之前的子字符串 bcd
        debugLog("subString = \(subString)")
    }
    
}

// MARK: NSAttributedString and NSRange
struct PAAttributedString {
    
    static func attributedString(string: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: " " + string + "  ")
        let mAttributedString = NSMutableAttributedString(attributedString: attributedString)
        let range = NSRange(location: string.characters.count + 1, length: 1)
        let textAttachment = NSTextAttachment()
//        // font.descender, font.lineHeight, font.lineHeight
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        textAttachment.image = #imageLiteral(resourceName: "leftBackButton")
        let replaceAttributedString = NSAttributedString(attachment: textAttachment)
        mAttributedString.replaceCharacters(in: range, with: replaceAttributedString)
//
        mAttributedString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 10)], range: NSMakeRange(0, mAttributedString.length))
//        let resultString = mAttributedString.string
//        debugLog("resultString = \(resultString)")
//        let aRange = NSRange(location: 0, length: mAttributedString.length - 1)
//        return mAttributedString.attributedSubstring(from: aRange)
        let width = PAStringWidthMakeWithAttributedString(mAttributedString)
        debugLog("width1 = \(width)")
        
        return mAttributedString
    }
    
}

// MARK: Calendar
struct PADateHandel {
    
    static func learnCalendar() {
        //        debugLog(PADateHandel.dateString(dateFormat: "YYYY-MM-dd HH:mm:ss"))
        //        debugLog(PADateHandel.age(with: "2017-04-01"))
        //        debugLog(PADateHandel.age(with: "2017-04-30 18:20:20"))
        //        debugLog(PADateHandel.age(with: "2017-04-25 18:20:20"))
        //        debugLog(PADateHandel.age(with: "2015-05-25 18:20:20"))
        debugLog(PADateHandel.age(with: "2015-08-25"))
        debugLog(PADateHandel.age(with: "2015-03-01"))
        // 2017-03-01
        debugLog(PADateHandel.age(with: "2017-03-01"))
    }
    
    static func age(with birthDay: String, ageName: String = "岁", monthName: String = "个月") -> String {
        var dateFormat = "yyyy-MM-dd"
        if birthDay.characters.count == 10 {
            dateFormat = "yyyy-MM-dd"
        } else if birthDay.characters.count == 19 {
            dateFormat = "yyyy-MM-dd HH:mm:ss"
        } else {
            return ""
        }
        guard let date = self.date(from: birthDay, dateFormat: dateFormat) else {
            return ""
        }
        let calendar = Calendar(identifier: .gregorian)
        
        var component = calendar.dateComponents([.year, .month], from: date, to: Date())
        
//        if let birthYear = Int(self.dateString(from: date, dateFormat: "YYYY")),
//            let currentYear = Int(self.dateString(dateFormat: "YYYY")) {
//            if currentYear - birthYear >= 2 {
//                return "\(currentYear - birthYear)" + ageName
//            }
//        }
        
        if let year = component.year, let month = component.month {
            if year == 0 && month == 0 {
                return "0" + ageName + "1" + monthName
            } else if year < 2 {
                return "\(year)" + ageName + (month == 0 ? "" : "\(month)\(monthName)")
            } else {
                return "\(year)" + ageName
            }
        }
        return ""
    }
    
    static func dateString(from date: Date = Date(), dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    
    static func date(from dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
}

