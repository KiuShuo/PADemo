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
    var distanceTop: CGFloat = 15
    var distanceBottom: CGFloat = 15
    weak var alertView: PAAlertView!
    // coverView...
    lazy var coverView = UIView()
    var coverViewWidth: CGFloat {
        return alertView.popupWidth
    }
    var coverViewMaxHeight: CGFloat {
        return alertView.popupMaxHeight
    }
    // titleLabel...
    var title: String?
    var titleTextColor: UIColor {
        return alertView.titleTextColor
    }
    var titleFont: UIFont {
        return alertView.titleFont
    }
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
    var messageTextAlignment: NSTextAlignment {
        return alertView.messageTextAlignment
    }
    var messageTextColor: UIColor {
        return alertView.messageTextColor
    }
    var messageFont: UIFont {
        return alertView.messageFont
    }
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
    
    var lastCoverSubView: UIView?
    
    func alertCoverView() -> UIView {
        coverView.subviews.forEach { $0.removeFromSuperview() }
        setupTitleLabel()
        setupDetailLabel()
        setupTextField()
        setupCustomView()
        if lastCoverSubView != nil {
            lastCoverSubView!.pa_alignBottomToParent(with: -distanceBottom).priority = 999
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
            titleLabel.pa_alignTopToParent(with: distanceTop)
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
            messageLabel.pa_alignTopToParent(with: distanceTop)
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
                textField.pa_alignToParent(with: distanceTop + textFieldHeight * CGFloat(i))
            }
            if i == textFields.count - 1 {
                lastCoverSubView = textField
            }
        }
    }
    
    private func setupCustomView() {
        guard let customView = customView else {
            return
        }
        coverView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.pa_setWidth(coverViewWidth - 30)
        customView.pa_centerHorizontally()
        if lastCoverSubView != nil {
            customView.pa_place(below: lastCoverSubView!, margin: 15)
        } else {
            customView.pa_alignTopToParent(with: distanceTop)
        }
        customView.pa_setHeight(customView.frame.size.height)
        lastCoverSubView = customView
    }
    
    func alertCoverViewHeight() -> CGFloat {
        let height = coverView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return height
    }
    
}

