//
//  DetailViewController.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
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
//        debugLog(PADateHandel.dateString(dateFormat: "YYYY-MM-dd HH:mm:ss"))
        setupAutoHeightLabel()
//        debugLog(PADateHandel.age(with: "2017-04-01"))
//        debugLog(PADateHandel.age(with: "2017-04-30 18:20:20"))
//        debugLog(PADateHandel.age(with: "2017-04-25 18:20:20"))
//        debugLog(PADateHandel.age(with: "2015-05-25 18:20:20"))
        debugLog(PADateHandel.age(with: "2015-08-25"))
        debugLog(PADateHandel.age(with: "2015-03-01"))
        // 2017-03-01
        debugLog(PADateHandel.age(with: "2017-03-01"))
    }
    
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

struct PADateHandel {
    
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

