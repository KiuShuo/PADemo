//
//  PAPlaceholderTextView.swift
//  asdfaf
//
//  Created by luozhijun on 2017/2/13.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

/** 混合型图片模型, 主要考虑到, 一张图片既可由url指代, 也可直接由矩阵向量描述 */
class PACompoundImage: Equatable {
    var image           : UIImage?
    var fullScreenImage : UIImage?
    var urlString       : String?
    
    class func instances(with images: [UIImage?]) -> [PACompoundImage] {
        var result = [PACompoundImage]()
        for image in images {
            let item = PACompoundImage()
            item.image = image
            result.append(item)
        }
        return result
    }
    
    class func instances(with urlStrings: [String?]) -> [PACompoundImage] {
        var result = [PACompoundImage]()
        for urlString in urlStrings {
            let item = PACompoundImage()
            item.urlString = urlString
            result.append(item)
        }
        return result
    }
    
    static func == (lhs: PACompoundImage, rhs: PACompoundImage) -> Bool {
        return lhs.image == rhs.image && lhs.urlString == rhs.urlString
    }
}

/** 支持显示占位(提醒)文字的TextView */
@IBDesignable class PAPlaceholderTextView: UITextView {
    
    //MARK: - Properties
    @IBInspectable var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    var placeholderAttributes: [NSAttributedStringKey: Any] = defaultPlaceholderAttributes {
        didSet {
            if let font = placeholderAttributes[NSAttributedStringKey.font] as? UIFont {
                placeholderLabel.font = font
            }
            if let color = placeholderAttributes[NSAttributedStringKey.foregroundColor] as? UIColor {
                placeholderLabel.textColor = color
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var attributedPlaceholder: NSAttributedString? {
        didSet {
            if let attributedPlaceholder = attributedPlaceholder, attributedPlaceholder.length > 0 {
                placeholderLabel.attributedText = attributedPlaceholder
            }
        }
    }
    
    static private var defaultPlaceholderAttributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    }
    private var placeholderLabel = UILabel()
    var placeholderX: CGFloat = 10 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var placeholderY: CGFloat = 10 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    private func defaultOperation() {
        placeholderLabel               = UILabel()
        placeholderLabel.text          = placeholder
        placeholderLabel.font          = placeholderAttributes[NSAttributedStringKey.font] as! UIFont
        placeholderLabel.textColor     = placeholderAttributes[NSAttributedStringKey.foregroundColor] as! UIColor
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: .UITextViewTextDidChange, object: self)
    }
    
    required init(placeholder: String?, placeholderAttributes: [NSAttributedStringKey: Any] = defaultPlaceholderAttributes, textContainer: NSTextContainer? = nil) {
        super.init(frame: .zero, textContainer: textContainer)
        self.placeholder               = placeholder
        self.placeholderAttributes     = placeholderAttributes
        
        defaultOperation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultOperation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let palceholderMaxWidth = frame.width - 2 * placeholderX
        let needSize = placeholderLabel.sizeThatFits(CGSize(width: palceholderMaxWidth, height: CGFloat.greatestFiniteMagnitude))
        placeholderLabel.frame = CGRect(x: placeholderX, y: placeholderY, width: needSize.width, height: needSize.height)
    }
    
    @objc private func textDidChange() {
        if text?.isEmpty == false {
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
    }
}
