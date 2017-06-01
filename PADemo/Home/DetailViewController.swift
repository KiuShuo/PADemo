//
//  DetailViewController.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//  1.Calendar 用法
//

import UIKit

class DetailViewController: BaseViewController {
    
    static func makeViewController(viewControllerClass: BaseViewController.Type) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self))
    }
    // "现场查看是否有铅衣等防护用品，且可使用；比如齿科的全景X光机；无放射科则不适用\n（需有照片）"
    let text = "现场查看是否有铅衣等防护用品，且可使用；比如齿科的全景X光机；无放射科则不适用（需有照片）"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // label size
        //setupAutoHeightLabel()
        
        // Calendar
        // PADateHandel.learnCalendar()
        
        // range
        PARange.learnRange()
        
        debugLog(navigationItem.leftBarButtonItem ?? "")
        
        
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 10, height: 30))
        view.addSubview(label)
        let attributedString = PAAttributedString.attributedString(string: "abcde")
//        let mA = NSMutableAttributedString(attributedString: attributedString)
        let width = attributedString.size().width + 10.0
        debugLog("width = \(width)")
        label.attributedText = attributedString
        let width2 = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)).width
        debugLog("width2 = \(width2)")
        label.mas_makeConstraints { (make) in
            make!.left.equalTo()(100)
            make!.top.equalTo()(100)
            make!.height.equalTo()(30)
//            make!.width.equalTo()(width)
        }
        
        label.backgroundColor = UIColor.green
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.red.cgColor
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

