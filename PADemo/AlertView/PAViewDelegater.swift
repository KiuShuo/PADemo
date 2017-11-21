//
//  PABaseAlertCoverViewDelegater.swift
//  PADemo
//
//  Created by shuo on 2017/11/21.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation

// titleLabel + messageLabel + customView
class PABaseAlertCoverViewDelegater: PAAlertCoverViewDelegate {
    // titleLabel...
    var title: String?
    var titleTextColor: UIColor = UIColor(red: 255/255, green: 102/255, blue: 2/255, alpha: 1)
    var titleFont: UIFont = UIFont.systemFont(ofSize: 17)
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = self.title
        titleLabel.textColor = self.titleTextColor
        titleLabel.font = self.titleFont
        return titleLabel
    }()
    // messageLable...
    var messageTitle: String?
    var attributeString: NSAttributedString?
    var messageTextAlignment: NSTextAlignment = .center
    var messageTextColor: UIColor = UIColor(red: 50/255,
                                            green: 51/255,
                                            blue: 53/255,
                                            alpha: 1)
    var messageFont = UIFont.systemFont(ofSize: 15)
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = self.messageTextAlignment
        if let attributeString = self.attributeString {
            messageLabel.attributedText = attributeString
        } else {
            messageLabel.text = self.messageTitle
            messageLabel.textColor = self.messageTextColor
            messageLabel.font = self.messageFont
        }
        return messageLabel
    }()
    // textField...
    var textFields: [UITextField] = []
    var textFieldHeight: CGFloat = 30.0
    // customView...
    var customView: UIView?
    // coverView
    lazy var coverView = UIView()
    private var coverViewWidth: CGFloat = 255
    var coverViewMaxHeight: CGFloat = UIScreen.main.bounds.size.height - 2 * UIApplication.shared.statusBarFrame.size.height
    
    var lastCoverSubView: UIView?
    
    func alertCoverView() -> UIView {
        coverView.frame = CGRect(x: 0, y: 0, width: coverViewWidth, height: 0)
        coverView.subviews.forEach { $0.removeFromSuperview() }
        setupTitleLabel()
        setupDetailLabel()
        setupTextField()
        setupCustomView()
        if lastCoverSubView != nil {
            lastCoverSubView!.pa_alignBottomToParent(with: -15) //.priority = 999
        }
        return coverView
    }
    
    private func setupTitleLabel() {
        guard let titleStr = title else {
            return
        }
        titleLabel.text = titleStr
        coverView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.pa_alignLeftToParent(with: 15)
        titleLabel.pa_alignRightToParent(with: -15)
        if lastCoverSubView != nil {
            titleLabel.pa_place(below: lastCoverSubView!, margin: 15)
        } else {
            titleLabel.pa_alignTopToParent(with: 15)
        }
        let size = titleLabel.sizeThatFits(CGSize(width: coverViewWidth - 30, height: coverViewMaxHeight))
        titleLabel.pa_setHeight(size.height)
        lastCoverSubView = titleLabel
    }
    
    private func setupDetailLabel() {
        if messageTitle == nil && attributeString == nil {
            return
        }
        coverView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.pa_alignLeftToParent(with: 15)
        messageLabel.pa_alignRightToParent(with: -15)
        if lastCoverSubView != nil {
            messageLabel.pa_place(below: lastCoverSubView!, margin: 15)
        } else {
            messageLabel.pa_alignTopToParent(with: 15)
        }
        let size = messageLabel.sizeThatFits(CGSize(width: coverViewWidth - 30, height: coverViewMaxHeight))
        messageLabel.pa_setHeight(size.height)
        lastCoverSubView = messageLabel
    }
    
    private func setupTextField() {
        if textFields.isEmpty {
            return
        }
        for i in 0..<textFields.count {
            let textField = textFields[i]
            let leftPlaceView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textFieldHeight))
            textField.leftViewMode = .always
            textField.leftView = leftPlaceView
            coverView.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            let textFieldWidth = coverViewWidth - 30
            textField.pa_setWidth(textFieldWidth)
            textField.pa_centerHorizontally()
            textField.pa_setHeight(textFieldHeight)
            if lastCoverSubView != nil {
                textField.pa_place(below: lastCoverSubView!, margin: 15 + textFieldHeight * CGFloat(i))
            } else {
                textField.pa_alignToParent(with: 15 + textFieldHeight * CGFloat(i))
            }
            if i == textFields.count - 1 {
                lastCoverSubView = textField
            }
        }
    }
    
    private func setupCustomView() {
        guard let customView = customView else {
            if lastCoverSubView != nil {
                lastCoverSubView?.pa_alignBottomToParent(with: 15)
            }
            return
        }
        coverView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.pa_alignLeftToParent()
        customView.pa_alignRightToParent()
        if lastCoverSubView != nil {
            customView.pa_place(below: lastCoverSubView!, margin: 15)
        } else {
            customView.pa_alignTopToParent(with: 0)
        }
        customView.pa_setHeight(customView.frame.size.height)
        lastCoverSubView = customView
    }
    
    func alertCoverViewHeight() -> CGFloat {
        let height = coverView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return height
    }
    
}
