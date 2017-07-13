//
//  PAAlertView.swift
//  PAAlertView
//
//  Created by shuo on 2016/12/26.
//  Copyright © 2016年 shuo. All rights reserved.
//

import UIKit
import IQKeyboardManager

// 常用扩展
extension PAAlertView {
    
    // 一个按钮的alert
    @discardableResult
    static func showBaseAlert(title: String? = nil, message: String? = nil, buttonTitle: String = "确定", clickButton: (() -> Void)? = nil) -> PAAlertView {
        let alertView = PAAlertView(title: title, message: message)
        let doneAction = PAAlertViewAction(title: buttonTitle) { _ in
            if let clickButton = clickButton {
                clickButton()
            }
        }
        alertView.addAction(doneAction)
        alertView.show()
        return alertView
    }
    
    // 两个按钮的alert
    @discardableResult
    static func showBaseAlertWithTwoAction(title: String? = nil, message: String? = nil, cancelButtonStr: String = "取消", sureButtonStr: String = "确定", clickCancelButton: (() -> Void)? = nil, clickSureButton: (() -> Void)? = nil) -> PAAlertView {
        let alertView = PAAlertView(title: title, message: message)
        let cancelAction = PAAlertViewAction(title: cancelButtonStr) { _ in
            if let clickCancelButton = clickCancelButton {
                clickCancelButton()
            }
        }
        alertView.addAction(cancelAction)
        let doneAction = PAAlertViewAction(title: sureButtonStr) { _ in
            if let clickSureButton = clickSureButton {
                clickSureButton()
            }
        }
        alertView.addAction(doneAction)
        alertView.show()
        return alertView
    }
    
    // validateAlertView
    static func validateAlertView(title: String? = nil, message: String? = nil, content: String, cancelButtonStr: String = "取消", sureButtonStr: String = "确定", clickCancelButton: (() -> Void)? = nil, clickSureButton: (() -> Void)? = nil, clickContentButton: (() -> Void)? = nil) -> PAAlertView {
        let alertView = PAAlertView(title: title, message: message)
        
        let cancelAction = PAAlertViewAction(title: cancelButtonStr) { _ in
            if let clickCancelButton = clickCancelButton {
                clickCancelButton()
            }
        }
        cancelAction.buttonTextColor = UIColor.black
        alertView.addAction(cancelAction)
        let doneAction = PAAlertViewAction(title: sureButtonStr) { _ in
            if let clickSureButton = clickSureButton {
                clickSureButton()
            }
        }
        
        let contentButton = PAButton(type: .custom)
        contentButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentButton.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        contentButton.setTitle(content, for: .normal)
        contentButton.setTitleColor(UIColor.paOrangeColor(), for: .normal)
        contentButton.setTitleColor(UIColor.paHighOrangeColor(), for: .highlighted)
        alertView.addCustomView(view: contentButton)
        contentButton.addClickEvent { 
            if let clickContentButton = clickContentButton {
                clickContentButton()
            }
        }
        alertView.addAction(doneAction)
        
        return alertView
    }
    

}

fileprivate protocol PAAlertViewActionDelegate: class {
    
    func didTap(action: PAAlertViewAction)
    
}

class PAAlertViewAction {
    
    fileprivate var buttonTitle: String?
    var fontSize: CGFloat = 16
    var isBoldForButtonText: Bool = false
    var buttonTextColor: UIColor = UIColor(red: 255/255, green: 102/255, blue: 2/255, alpha: 1)
    var buttonHighlightedColor: UIColor = UIColor(red: 236 / 255.0, green: 236 / 255.0, blue: 236 / 255.0, alpha: 1)
    var buttonTextHighlightedColor: UIColor = UIColor(red: 255/255, green: 102/255, blue: 2/255, alpha: 1)
    var buttonBackgroundColor: UIColor?
    var isAutoDismissAlertView: Bool = true
    
    fileprivate weak var delegate: PAAlertViewActionDelegate?
    
    private var handlerBlock: ((PAAlertViewAction) -> Void)?
    
    init(title: String? = "确定",
         handler: ((PAAlertViewAction) -> Void)? = nil) {
        if let theTitle = title, !theTitle.isEmpty {
            buttonTitle = theTitle
        } else {
            buttonTitle = "确定"
        }
        handlerBlock = handler
    }
    
    @objc func didTap() {
        if let handler = handlerBlock {
            handler(self)
        }
        if isAutoDismissAlertView {
            self.delegate?.didTap(action: self)
        }
    }
}

class PAAlertView: UIView {
    
    var actionSeparatorColor: UIColor = UIColor(red: 50/255,
                                                green: 51/255,
                                                blue: 53/255,
                                                alpha: 0.12)
    
    var titleTextColor: UIColor = UIColor(red: 255/255, green: 102/255, blue: 2/255, alpha: 1)
    
    var messageTextColor: UIColor = UIColor(red: 50/255,
                                            green: 51/255,
                                            blue: 53/255,
                                            alpha: 1)
    
    var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var messageFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            messageLabel.font = messageFont
        }
    }
    
    var isWindowLevelAlert: Bool = false
    var alertBackgroundColor: UIColor = UIColor.white
    var showInView: UIView?
    
    var messageTextAlignment: NSTextAlignment = .center
    var popupWidth: CGFloat = 255.0
    var popupMaxHeight: CGFloat = UIScreen.main.bounds.size.height - 20
    var textFieldHeight: CGFloat = 30.0
    private var coverViewHeight: CGFloat = 0
    private var buttonViewHeight: CGFloat = 0
    
    private let separatorThickness: CGFloat = 1.0 / UIScreen.main.scale
    
    private var buttonsHeight: CGFloat {
        get {
            return self.actions.count > 0 ? 44.0 : 0
        }
    }
    private var isKeyboardManagerEnable : Bool = false
    private var isActionButtonsVertical: Bool = false
    private var alertWindow: UIWindow?
    private var popupViewInitialFrame: CGRect!
    private var maskControl: UIControl = UIControl()
    private var popupView: UIView = UIView()
    private var coverView: UIScrollView = UIScrollView()
    private var buttonView: UIScrollView = UIScrollView()
    private var textFields = [UITextField]()
    private var customView: UIView?
    private var lastCoverSubView: UIView?
    private var titleLabel: UILabel = UILabel()
    private var messageLabel: UILabel = UILabel()
    private var attributeString: NSAttributedString?
    private lazy var actions: [PAAlertViewAction] = [PAAlertViewAction]()
    
    private var popupViewCenterYLayoutConstraint: NSLayoutConstraint?
    
    public convenience init(title: String?,
                            message: String?) {
        self.init()
        backgroundColor = UIColor(red: 50/255, green: 51/255, blue: 53/255, alpha: 0.4)
        if let title = title {
            titleLabel.text = title
        }
        if let message = message {
            messageLabel.text = message
        }
        
        addSubview(maskControl)
        maskControl.pa_alignToParent(with: 0)
    }
    
    public convenience init(title: String?, attributeString: NSAttributedString?) {
        self.init()
        backgroundColor = UIColor(red: 50/255, green: 51/255, blue: 53/255, alpha: 0.4)
        if let title = title {
            titleLabel.text = title
        }
        self.attributeString = attributeString
        
        addSubview(maskControl)
        maskControl.pa_alignToParent(with: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addAction(_ action: PAAlertViewAction) {
        actions.append(action)
    }
    @discardableResult
    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderWidth = separatorThickness
        textField.layer.borderColor = actionSeparatorColor.cgColor
        textField.font = UIFont.systemFont(ofSize: 13)
        // 添加键盘弹出消失的通知
        addKeyboardNotification()
        
        if let configurationHandler = configurationHandler {
            configurationHandler(textField)
        }
        textFields.append(textField)
        return textField
    }
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_ :)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_ :)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func addCustomView(view: UIView) {
        customView = view
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let frame = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue else {
            return
        }
        let popupViewBottomMarginTop = popupView.frame.origin.y + popupView.frame.size.height
        let keyboardOriginY = frame.origin.y
        let distance = keyboardOriginY - popupViewBottomMarginTop
        if distance < 0 {
            popupViewCenterYLayoutConstraint?.constant = distance - 10
        }
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        popupViewCenterYLayoutConstraint?.constant = 0
    }
    
    
    func show(isAnimated: Bool = true, completion: (() -> Void)? = nil) {
        let manager = IQKeyboardManager.shared()
        isKeyboardManagerEnable = manager.isEnabled
        manager.isEnabled = false
        if let showInView = showInView {
            showInView.addSubview(self)
        } else {
            if isWindowLevelAlert {
                alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow?.windowLevel = UIWindowLevelAlert
                alertWindow?.isHidden = false
                alertWindow?.backgroundColor = UIColor.clear
            } else {
                alertWindow = UIApplication.shared.keyWindow
            }
            
            alertWindow?.addSubview(self)
        }
        
        pa_alignToParent(with: 0)
        
        if !isActionButtonsVertical && actions.count > 2 {
            isActionButtonsVertical = true
        }
        configureViews()
        roundOfPopupView()
        
        if isAnimated {
            
            self.alpha = 0
            popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
                self.popupView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion:{ animated in
                UIView.animate(withDuration: 0.2, animations: {
                    self.popupView.transform = CGAffineTransform.identity
                }, completion: { animated in
                    if let completion = completion {
                        completion()
                    }
                })
            })
        } else {
            if let completion = completion {
                completion()
            }
        }
    }
    
    func dismiss() {
        let manager = IQKeyboardManager.shared()
        manager.isEnabled = isKeyboardManagerEnable
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { (_) in
            self.removeFromSuperview()
            if self.isWindowLevelAlert {
                self.alertWindow = nil
            }
        })

    }
    
    private func roundOfPopupView() {
        let roundCornersPath = UIBezierPath(roundedRect: CGRect(x: 0.0,
                                                                y: 0.0,
                                                                width: popupWidth,
                                                                height: popupView.frame.size.height),
                                            byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                            cornerRadii: CGSize(width: 8.0,
                                                                height: 8.0))
        let roundLayer = CAShapeLayer()
        roundLayer.path = roundCornersPath.cgPath
        popupView.layer.mask = roundLayer
    }
    
    private func configureViews() {
        popupView.backgroundColor = UIColor.clear
        maskControl.addSubview(popupView)
        
        configureCoverView()
        configureButtonView()
        
        // 如果是从代码层面开始使用Autolayout,需要对使用的View的translatesAutoresizingMaskIntoConstraints的属性设置为false.
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.pa_centerHorizontally()
        popupViewCenterYLayoutConstraint = popupView.pa_centerVertically()
        popupView.pa_setWidth(popupWidth)
        popupView.pa_setMaxHeight(popupMaxHeight)
        popupView.sizeToFit()
        popupView.layoutIfNeeded()
        popupView.updateConstraintsIfNeeded()
        if actions.count == 0 {
            maskControl.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doNothing))
        maskControl.addGestureRecognizer(panGesture)
    }
    
    @objc private func doNothing() {
        //
    }
    
    private func configureCoverView() {
        coverView.delaysContentTouches = false
        for subView in coverView.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delaysContentTouches = false
            }
        }
        coverView.backgroundColor = alertBackgroundColor
        coverView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(coverView)
        coverView.sizeToFit()
        coverView.layoutIfNeeded()
        coverView.pa_alignTopToParent(with: 0)
        coverView.pa_alignLeftToParent(with: 0)
        coverView.pa_alignRightToParent(with: 0)
        
        configureTitleLabel()
        configureMessageLabel()
        configureTextField()
        configureCustomView()
        
        coverViewHeight += coverViewHeight > 0 ? 15 : 0
        
        if coverViewHeight > popupMaxHeight * 2.0 / 3.0 {
            coverViewHeight = popupMaxHeight * 2.0 / 3.0
        }
        coverView.pa_setHeight(coverViewHeight)
    }
    
    private func configureTitleLabel() {
        lastCoverSubView = titleLabel
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleTextColor
        titleLabel.font = titleFont
        coverView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelWidth: CGFloat = popupWidth - 30
        titleLabel.pa_setWidth(titleLabelWidth)
        titleLabel.pa_centerHorizontally()
        let size = titleLabel.sizeThatFits(CGSize(width: popupWidth - 30, height: popupMaxHeight))
        var height = size.height
        if let title = titleLabel.text, !title.isEmpty {
            titleLabel.pa_alignTopToParent(with: 15)
        } else {
            titleLabel.pa_alignTopToParent(with: 0)
            height = 0
        }
        titleLabel.pa_setHeight(height)
        coverViewHeight = height > 0 ? (height + 15) : 0
    }
    
    private func configureMessageLabel() {
        lastCoverSubView = messageLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = messageTextAlignment
        if let attributeString = attributeString {
            messageLabel.attributedText = attributeString
        } else {
            messageLabel.textColor = messageTextColor
            messageLabel.font = messageFont
        }
        coverView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let messageTextViewWidth: CGFloat = popupWidth - 30
        messageLabel.pa_setWidth(messageTextViewWidth)
        messageLabel.pa_centerHorizontally()
        
        let size = messageLabel.sizeThatFits(CGSize(width: messageTextViewWidth, height: CGFloat(popupMaxHeight)))
        var messageHeight = size.height
        if let message = messageLabel.text, !message.isEmpty {
            messageLabel.pa_place(below: titleLabel, margin: 15)
            coverViewHeight += messageHeight + 15
        } else {
            messageHeight = 0
            messageLabel.pa_place(below: titleLabel, margin: 0)
        }
        messageLabel.pa_setHeight(messageHeight)
        if textFields.isEmpty {
            messageLabel.pa_alignBottomToParent(with: 15)
        }
    }
    
    private func configureTextField() {
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
            let textFieldWidth = popupWidth - 30
            textField.pa_setWidth(textFieldWidth)
            textField.pa_centerHorizontally()
            textField.pa_setHeight(textFieldHeight)
            textField.pa_place(below: messageLabel, margin: 15 + textFieldHeight * CGFloat(i))
            if i == textFields.count - 1 {
                textField.pa_alignBottomToParent(with: 15)
            }
            lastCoverSubView = textField
        }
        coverViewHeight += textFieldHeight * CGFloat(textFields.count) + 15
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        coverView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func configureCustomView() {
        guard let customView = customView else {
            return
        }
        coverView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.pa_setWidth(popupWidth - 30)
        customView.pa_setHeight(customView.frame.size.height)
        customView.pa_centerHorizontally()
        if let lastCoverSubView = lastCoverSubView {
            customView.pa_place(below: lastCoverSubView, margin: 15)
        } else {
            customView.pa_alignTopToParent(with: 15)
        }
        coverViewHeight += customView.frame.size.height + 15
    }
    
    private func configureButtonView() {
        buttonView.delaysContentTouches = false
        for subView in buttonView.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delaysContentTouches = false
            }
        }
        
        buttonView.backgroundColor = alertBackgroundColor
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(buttonView)
        buttonView.pa_place(below: coverView, margin: 0)
        buttonView.pa_alignLeftToParent(with: 0)
        buttonView.pa_alignRightToParent(with: 0)
        buttonView.pa_alignBottomToParent(with: 0)
        
        if !isActionButtonsVertical {
            buttonViewHeight = buttonsHeight + (actions.count > 0 ?
                separatorThickness : 0.0)
        } else {
            buttonViewHeight = (buttonsHeight + separatorThickness) * CGFloat(actions.count)
        }
        
        let backgroundColoredView = UIView(frame: .zero)
        backgroundColoredView.backgroundColor = actionSeparatorColor
        buttonView.addSubview(backgroundColoredView)
        backgroundColoredView.pa_alignToParent(with: 0)
        backgroundColoredView.pa_setWidth(popupWidth)
        backgroundColoredView.pa_setHeight(buttonViewHeight)
        
        if buttonViewHeight + coverViewHeight > popupMaxHeight {
            buttonViewHeight = popupMaxHeight - coverViewHeight
        }
        buttonView.pa_setHeight(buttonViewHeight)
        
        loadActionButtons()
    }
    
    private func loadActionButtons() {
        guard actions.count != 0 else { return }
        for button in buttonView.subviews {
            if button is UIButton {
                button.removeFromSuperview()
            }
        }
        var lastButton: UIButton? = nil
        for action in actions {
            action.delegate = self
            let button = UIButton(type: .custom)
            button.backgroundColor = action.buttonBackgroundColor ?? alertBackgroundColor
            
            button.setTitle(action.buttonTitle, for: .normal)
            button.setTitleColor(action.buttonTextColor, for: .normal)
            button.setTitleColor(action.buttonTextHighlightedColor, for: .highlighted)
            
            let hightedImage = UIImage(color: action.buttonHighlightedColor, size: CGSize(width: 60, height: 50))
            button.setBackgroundImage(hightedImage, for: .highlighted)
            
            if action.isBoldForButtonText {
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: action.fontSize)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: action.fontSize)
            }
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.addTarget(action, action: #selector(action.didTap), for: .touchUpInside)
            buttonView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            var buttonWidth: CGFloat = 0
            if isActionButtonsVertical {
                buttonWidth = popupWidth
                if let theLastButton = lastButton {
                    button.pa_place(below: theLastButton, margin: separatorThickness)
                } else {
                    button.pa_alignTopToParent(with: separatorThickness)
                }
                button.pa_alignLeftToParent(with: 0)
            } else {
                buttonWidth = (popupWidth - CGFloat(actions.count - 1) * separatorThickness) / CGFloat(actions.count)
                button.pa_alignTopToParent(with: separatorThickness)
                if let theLastButton = lastButton {
                    button.pa_alignToLeft(of: theLastButton, margin: (buttonWidth + separatorThickness))
                } else {
                    button.pa_alignLeftToParent(with: 0)
                }
            }
            
            button.pa_setWidth(buttonWidth)
            button.pa_setHeight(CGFloat(buttonsHeight))
            lastButton = button
        }
    }
    
}

extension PAAlertView: PAAlertViewActionDelegate {
    
    func didTap(action: PAAlertViewAction) {
        self.dismiss()
    }
    
}
