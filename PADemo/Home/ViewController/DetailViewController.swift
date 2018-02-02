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
//import WJExtension

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var bottomRightView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    static func makeViewController(viewControllerClass: BaseViewController.Type) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self))
    }
    // "现场查看是否有铅衣等防护用品，且可使用；比如齿科的全景X光机；无放射科则不适用\n（需有照片）"
    let text = "现场查看是否有铅衣等防护用品且可使用比如齿科的全景X光机无放射科则不适用（需有照片）"
    let shortText = "现场查看是否有铅衣等"
    let button = PAButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testPAButton()
        attributedString()
//        testForPAView()
        
//        let imageUrlStr = "https://cdn.pixabay.com/photo/2017/03/13/10/31/greylag-goose-2139296_640.jpg"
//        _ = getImage(urlString: imageUrlStr)
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
        
        testAttributedString()
        
        
        let label = PALabel(frame: CGRect(x: 0, y: 100, width: 50, height: 50))
        label.text = "哈哈"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17)
        label.cornerRadius = 25
        label.borderWidth = 1
        label.borderColor = UIColor.black
//        label.backgroundColor = UIColor.red
        view.addSubview(label)
        
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickRightBarButton))
        self.navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    @objc func clickRightBarButton() {
        let atimer = Timer(timeInterval: 1.0, target: self, selector: #selector(repeatDoSomething), userInfo: nil, repeats: true)
        RunLoop.main.add(atimer, forMode: .commonModes)
        atimer.fire()
        timer = atimer
    }
    
    var timer: Timer?
    var i = 0
    
    @objc func repeatDoSomething() {
        i = i + 1
        print("123")
        if i == 10 {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func testAttributedString() {
        let aStr: NSMutableAttributedString = NSMutableAttributedString(string: "1000分")
        let tFont = UIFont.systemFont(ofSize: 32)
        let range = NSRange(location: 0, length: aStr.length - 1)
        aStr.dz_setFont(tFont, range: range)
        let eFont = UIFont.systemFont(ofSize: 14)
        let aRange = NSRange(location: aStr.length - 1, length: 1)
        aStr.dz_setBaselineOffset(1.5, range: aRange) // 设置基线偏移值 正直向上偏移 负值向下偏移
        aStr.dz_setFont(eFont, range: aRange)
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 150, width: 100, height: 50))
        view.addSubview(label)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.red
        label.attributedText = aStr
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

    func attributedString() {
        let label = PALabel(frame: CGRect(x: 10, y: 230, width: 200, height: 80))
        label.numberOfLines = 0
        label.backgroundColor = UIColor.green
        let originStr = text//"123456789012345678908875546888827364657681.56万"
        let mAtt = NSMutableAttributedString(string: originStr)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0.34 // 行间距
        let length = text.count
        let range = NSMakeRange(0, length)
        style.lineBreakMode = .byTruncatingTail
        mAtt.addAttributes([NSAttributedStringKey.paragraphStyle: style], range: range)
        mAtt.dz_setFont(UIFont.systemFont(ofSize: 11), range: NSMakeRange(originStr.count - 1, 1))
        mAtt.dz_setFont(UIFont.systemFont(ofSize: 24), range: NSMakeRange(0, originStr.count - 1))
        mAtt.dz_setBaselineOffset(1.5, range: NSMakeRange(originStr.count - 1, 1))
        label.textAlignment = .left
        label.verticalAlignment = .bottom
        label.attributedText = mAtt
        view.addSubview(label)
    }
    

}

// PAViewTest
extension DetailViewController {
    
    func testPAButton() {
        button.backgroundColor = UIColor.blue
        button.frame = CGRect(x: 10, y: 80, width: 50, height: 30)
//        button.highlightedBackgroundColor = UIColor.green
        view.addSubview(button)
        button.addTarget(self, action: #selector(handelTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(handelTouchCancel), for: .touchCancel)
        button.addTarget(self, action: #selector(handelTouchCancel), for: .touchUpOutside)
        button.addTarget(self, action: #selector(handelTouch), for: .touchUpInside)
//        button.addObserver(self, forKeyPath: "state", options: .new, context: nil)
    }
    
    @objc func handelTouchDown() {
        self.view.backgroundColor = UIColor.red
    }
    
    @objc func handelTouchCancel() {
        self.view.backgroundColor = UIColor.white
    }
    
    @objc func handelTouch() {
        self.view.backgroundColor = UIColor.white
        print("dianji")
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("123")
//    }
    
    func testForPAView() {
        let greenView = PAView()
        greenView.frame = CGRect(x: 100, y: 200, width: 50, height: 30)
        greenView.backgroundColor = UIColor.green
        view.addSubview(greenView)
        greenView.maskLayer(cornerRadius: CGSize(width: 5, height: 5), rectCorner: [.topLeft, .bottomRight])
//        greenView.topLeftCornerRadius = CGSize(width: 5, height: 5)
        
//        raduisHandleView(view: greenView)
    }
    
    func raduisHandleView(view:UIView){
        let maskPath:UIBezierPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 25, height: 15))
        
        let maskLayer:CAShapeLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
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
        let subString = String(string[subRange])
        // 获取下标从1开始到下标为4之前的子字符串 bcd
        debugLog("subString = \(subString)")
    }
    
}

// MARK: NSAttributedString and NSRange
struct PAAttributedString {
    
    static func attributedString(string: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: " " + string + "  ")
        let mAttributedString = NSMutableAttributedString(attributedString: attributedString)
        let range = NSRange(location: string.count + 1, length: 1)
        let textAttachment = NSTextAttachment()
//        // font.descender, font.lineHeight, font.lineHeight
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        textAttachment.image = #imageLiteral(resourceName: "leftBackButton")
        let replaceAttributedString = NSAttributedString(attachment: textAttachment)
        mAttributedString.replaceCharacters(in: range, with: replaceAttributedString)
//
        mAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)], range: NSMakeRange(0, mAttributedString.length))
//        let resultString = mAttributedString.string
//        debugLog("resultString = \(resultString)")
//        let aRange = NSRange(location: 0, length: mAttributedString.length - 1)
//        return mAttributedString.attributedSubstring(from: aRange)

        
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
        if birthDay.count == 10 {
            dateFormat = "yyyy-MM-dd"
        } else if birthDay.count == 19 {
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

