//
//  PATableViewModelDemoCell.swift
//  PADemo
//
//  Created by shuo on 2017/6/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PATableViewModelDemoCell: UITableViewCell, PATableViewCellProtocol {

    static let cellModel: PACellModel = PACellModel(classType: PATableViewModelDemoCell.self, height: -1)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    var changeHeight: ((String) -> Void)?
    
    struct PATableViewModel {
        var title: String?
    }
    
    var person: PAPerson?
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            if let model = dataModel as? PAPerson {
                self.person = model
                titleLabel.text = model.name
                ageLabel.text = "\(model.age)"
                textView.text = model.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        debugLog(String(describing: self.classForCoder) + "创建")
    }
    
    deinit {
        debugLog(String(describing: self.classForCoder) + "析构方法执行")
    }
    
    fileprivate func calculateTextViewHeight() -> CGFloat {
        let textViewSize = CGSize(width: UIScreen.width - 210, height: CGFloat.greatestFiniteMagnitude)
        return textView.sizeThatFits(textViewSize).height
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 20
        let textViewHeight = calculateTextViewHeight()
        height += textViewHeight
        return CGSize(width: size.width, height: max(height, 44))
    }
    
    var textViewHeightValue: CGFloat = 0 {
        willSet {
            if newValue != textViewHeightValue, textViewHeightValue != 0 {
                person?.name = textView.text
                changeHeight?(textView.text)
            }
        }
    }
    var isTextViewEditing: Bool = false
    
}

extension PATableViewModelDemoCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        isTextViewEditing = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewHeight.constant = calculateTextViewHeight()
        textViewHeightValue = calculateTextViewHeight()
//        if isTextViewEditing {
//            changeHeight?(textView.text)
//        }
//        contentView.layoutIfNeeded()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isTextViewEditing = false
//        person?.age = textView.text.intValue
    }
    
}
