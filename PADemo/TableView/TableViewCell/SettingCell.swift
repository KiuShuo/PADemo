//
//  SettingCell.swift
//  feng
//
//  Created by luozhijun on 2016/11/23.
//  Copyright © 2016年 shuo. All rights reserved.
//

import UIKit
import SDWebImage
//import WJExtension

//MARK: - SettingCell
/** 设置、表单界面中的cell */
class SettingCell: UITableViewCell {
    
    //MARK: Properties
    static let reuseIdentifier = "ZJSettingCell"
    //增加cellModel类属性，使其可以在使用sectionModels创建cell的框架下使用
    static let cellModel: PACellModel = PACellModel(identifier: String(describing: SettingCell.self), height: 44, isRegisterByClass:true, classType: SettingCell.self)
    
    fileprivate var customBgImageView = UIImageView()
    fileprivate lazy var orderIcon: UIButton = {
        let orderIcon = UIButton()
        orderIcon.isUserInteractionEnabled = false
        orderIcon.setTitleColor(UIColor.white, for: .normal)
        orderIcon.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.customBgImageView.addSubview(orderIcon)
        return orderIcon
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        self.customBgImageView.addSubview(titleLabel)
        return titleLabel
    }()
    fileprivate lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        self.customBgImageView.addSubview(subtitleLabel)
        return subtitleLabel
    }()
    /** 右侧的箭头 */
    fileprivate lazy var accessoryArrow = UIImageView(image: UIImage(named: "pa_rightArrow"))
    /** 右侧的钩形图标, 指示是否选中, 虽然accessoryType有checkmark型, 但图标大小等与项目不合 */
    fileprivate lazy var accessoryCheckmark = UIImageView(image: UIImage(named: "selectTrue"))
    fileprivate lazy var sectionTitleLabel = UILabel()
    /** TextField */
    fileprivate lazy var textField: UITextField = {
        let textField = UITextField()
        textField.enablesReturnKeyAutomatically = true
        textField.font                          = self.item?.subtitleFont
        textField.textColor                     = self.item?.subtitleColor
        textField.delegate                      = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: .UITextFieldTextDidChange, object: textField)
        return textField
    }()
    /** textView */
    fileprivate lazy var textView: PAPlaceholderTextView = {
        let textView = PAPlaceholderTextView(placeholder: nil)
        textView.enablesReturnKeyAutomatically = true
        textView.font                          = self.item?.subtitleFont
        textView.textColor                     = self.item?.subtitleColor
        textView.delegate                      = self
        textView.backgroundColor               = (self.item as? SettingTextViewItem)?.textViewBackgroundColor ?? .paLightGray
        textView.layer.cornerRadius            = 4
        return textView
    }()
    fileprivate lazy var fullTextLabel = UILabel()
    fileprivate lazy var fullTextBgView: UIView = {
        let fullTextBgView = UIView()
        fullTextBgView.backgroundColor    = .paLightGray
        fullTextBgView.layer.cornerRadius = 4
        return fullTextBgView
    }()
    
    /** 缩略图网格 */
    lazy var thumbnialImageViews      = [UIImageView]()
    fileprivate lazy var rightButtons = [UIButton]()
    
    fileprivate var inputViewDidChangeText = false
    
    var indexPath: IndexPath?
    var item: SettingItem? {
        didSet {
            if item != nil {
                setupSubviews(by: item!)
            }
        }
    }
    var textViewDidBeginEditing: ((UITextView) -> Void)?
    
    weak var previewingController: UIViewController?
    
    //MARK: Life Cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(customBgImageView)
        customBgImageView.isUserInteractionEnabled = true
        
        let sBgView = UIView()
        selectedBackgroundView = sBgView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    fileprivate func setupSubviews(by item: SettingItem) {
        indexPath                = item.indexPath
        backgroundColor          = item.backgroundColor
        selectionStyle           = item.selectionStyle
        isUserInteractionEnabled = item.isUserInteractionEnabled
        
        if let selectedBgColor = item.selectedBackgroundColor {
            selectedBackgroundView?.backgroundColor = selectedBgColor
        } else {
            // 默认的选中背景色
            selectedBackgroundView?.backgroundColor = UIColor(R: 229, G: 229, B: 229, A: 1.0)
        }
        
        customBgImageView.image = item.backgroundImage
        customBgImageView.highlightedImage = item.highlightedBackgroundImage
        
        // 图标
        if item.iconName.isEmpty {
            imageView?.image = nil
        } else {
            imageView?.image = UIImage(named: item.iconName)
        }
        
        // 标题
        // Tag 20170524 发现用cell自带的textLabel在刷新cell时会偶然出现字体颜色改变问题, 故此处不再使用textLabel
        titleLabel.isHidden  = false
        if !item.isUserInteractionEnabled {
            titleLabel.textColor = item.disabledTitelColor
        } else {
            titleLabel.textColor = item.titleColor
        }
        if item.required && item.shouldAddAsteriskMarkWhenRequired {
            let attrTitle = NSMutableAttributedString(string: "* ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.paOrange, NSAttributedStringKey.font: item.titleFont])
            attrTitle.append(NSAttributedString(string: item.title.noneNull, attributes: [NSAttributedStringKey.font: item.titleFont, NSAttributedStringKey.foregroundColor: item.titleColor]))
            titleLabel.attributedText = attrTitle
        } else {
            titleLabel.font = item.titleFont
            titleLabel.text = item.title
        }
        
        // 子标题
        // Tag 20170524 发现用cell自带的detailTextLabel在刷新cell时会偶然出现字体颜色改变问题, 故此处不再使用detailTextLabel
        subtitleLabel.font          = item.subtitleFont
        if isUserInteractionEnabled {
            subtitleLabel.textColor = item.subtitleColor
        } else {
            subtitleLabel.textColor = item.subtitlePlaceholderColor
        }
        subtitleLabel.textAlignment = item.subtitleAlignment
        if item.attributedSubtitle != nil, item.attributedSubtitle?.length != 0 {
            subtitleLabel.attributedText = item.attributedSubtitle
        } else {
            subtitleLabel.text = item.subtitle
        }
        if (item.subtitle == nil || item.subtitle?.isEmpty == true) && (item.attributedSubtitle == nil || item.attributedSubtitle?.length == 0) && item.subtitlePlaceholder != nil {
            subtitleLabel.font          = item.subtitlePlaceholderFont
            subtitleLabel.textColor     = item.subtitlePlaceholderColor
            subtitleLabel.textAlignment = item.subtitlePlaceholderAlignment
            subtitleLabel.text          = item.subtitlePlaceholder
        }
        
        // accessoryView
        if let item = item as? SettingArrowItem, !item.isArrowHidden {
            accessoryView = accessoryArrow
        } else if let item = item as? SettingCheckmarkItem, item.isChecked {
            accessoryView = accessoryCheckmark
        } else {
            accessoryView = nil
        }
        
        // sectionHeaderLabel 段头label
        if let item = item as? SettingSectionHeaderItem {
            titleLabel.isHidden = true
            customBgImageView.addSubview(sectionTitleLabel)
            if item.headerIconName.isEmpty {
                imageView?.image = nil
            } else {
                imageView?.image = UIImage(named: item.headerIconName)
            }
            sectionTitleLabel.font      = item.titleFont
            sectionTitleLabel.textColor = item.titleColor
            sectionTitleLabel.text      = item.title
        } else {
            sectionTitleLabel.removeFromSuperview()
        }
        
        // textfield 输入框
        if let item = item as? SettingTextFieldItem {
            customBgImageView.addSubview(textField)
            subtitleLabel.text = nil
            textField.isUserInteractionEnabled = item.isUserInteractionEnabled
            if textField.isUserInteractionEnabled {
                textField.textColor = item.subtitleColor
            } else {
                textField.textColor = item.subtitlePlaceholderColor
            }
            textField.keyboardType = item.keyboardType
            textField.text = item.subtitle
            textField.textAlignment = item.subtitleAlignment
            textField.attributedPlaceholder = NSAttributedString(string: item.subtitlePlaceholder.noneNull, attributes: [NSAttributedStringKey.font: item.subtitlePlaceholderFont, NSAttributedStringKey.foregroundColor: item.subtitlePlaceholderColor])
            textField.textAlignment = item.subtitlePlaceholderAlignment
        } else {
            textField.removeFromSuperview()
        }
        
        // fullText
        if let item = item as? SettingFullTextItem, !(item is SettingTextViewItem) {
            customBgImageView.addSubview(fullTextBgView)
            fullTextBgView.addSubview(fullTextLabel)
            subtitleLabel.text = nil
            fullTextLabel.numberOfLines = 0
            fullTextLabel.font          = item.subtitleFont
            fullTextLabel.textColor     = item.subtitleColor
            fullTextLabel.textAlignment = item.subtitleAlignment
            fullTextLabel.text          = item.subtitle
            if (item.subtitle == nil || item.subtitle?.isEmpty == true) && item.subtitlePlaceholder?.isEmpty == false {
                fullTextLabel.font          = item.subtitlePlaceholderFont
                fullTextLabel.textColor     = item.subtitlePlaceholderColor
                fullTextLabel.textAlignment = item.subtitlePlaceholderAlignment
                fullTextLabel.text          = item.subtitlePlaceholder
            }
        } else {
            fullTextBgView.removeFromSuperview()
            fullTextLabel.removeFromSuperview()
        }
        
        // textView
        if let item = item as? SettingTextViewItem {
            customBgImageView.addSubview(textView)
            subtitleLabel.text = nil
            textView.placeholderAttributes = [NSAttributedStringKey.font: item.subtitlePlaceholderFont, NSAttributedStringKey.foregroundColor: item.subtitlePlaceholderColor]
            textView.isUserInteractionEnabled   = item.textViewEnable
            if isUserInteractionEnabled {
                textView.textColor = item.subtitleColor
            } else {
                textView.textColor = item.subtitlePlaceholderColor
            }
            textView.keyboardType = item.keyboardType
            textView.placeholder  = item.subtitlePlaceholder
            textView.placeholderX = item.placeholderX
            textView.placeholderY = item.placeholderY
            textView.text         = item.subtitle
        } else {
            textView.removeFromSuperview()
        }
        
        // thumbnails 缩略图
        if let item = item as? SettingImageGridItem {
            let imageCount = item.internalImages.count
            if thumbnialImageViews.count < imageCount {
                for index in thumbnialImageViews.count..<imageCount {
                    let imageView = UIImageView()
                    imageView.clipsToBounds = true
                    imageView.isUserInteractionEnabled = true
                    imageView.bounds.size = item.imageViewSize
                    imageView.tag = index
                    if #available(iOS 9.0, *), let previewingDelegate = previewingController as? UIViewControllerPreviewingDelegate {
                        previewingController?.registerForPreviewing(with: previewingDelegate, sourceView: imageView)
                    }
                    thumbnialImageViews.append(imageView)
                }
            }
            for index in 0..<imageCount {
                let compoundImage = item.internalImages[index]
                let imageView = thumbnialImageViews[index]
                if compoundImage.image == nil, let url = URL(string: compoundImage.urlString.noneNull) {
                    imageView.setShowActivityIndicator(true)
                    imageView.setIndicatorStyle(.gray)
                    imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "whiteplaceholder"), options: [.retryFailed, .avoidAutoSetImage]) { (image, error, cacheType, url) in
                        if error == nil, image != nil {
                            imageView.image = image
                            imageView.roundingImage(forRadius: item.imageCornerRadius, sizeToFit: item.imageViewSize)
                            compoundImage.image = imageView.image
                        }
                    }
                } else {
                    imageView.image = compoundImage.image
                }
                customBgImageView.addSubview(thumbnialImageViews[index])
            }
            for index in imageCount..<thumbnialImageViews.count {
                thumbnialImageViews[index].removeFromSuperview()
            }
        } else {
            thumbnialImageViews.forEach { $0.removeFromSuperview() }
        }
        
        // right action 右侧事件
        if let item = item as? SettingRightActionsItem {
            for index in 0..<item.buttonTitles.count {
                var btn: UIButton! = nil
                if index < rightButtons.count {
                    btn = rightButtons[index]
                } else {
                    btn = UIButton(type: .system)
                    rightButtons.append(btn)
                }
                customBgImageView.addSubview(btn)
                btn.isEnabled = item.isUserInteractionEnabled
                btn.setTitleColor(item.subtitlePlaceholderColor, for: .normal)
                btn.setTitle(item.buttonTitles[index], for: .normal)
                btn.titleLabel?.font    = item.subtitlePlaceholderFont
                btn.layer.cornerRadius  = 4
                btn.layer.masksToBounds = true
                btn.layer.borderWidth   = UIScreen.roundRectButtonBorderWidth
                if index >= 0 && index == item.highlightedButtonIndex {
                    btn.setTitleColor(item.highlightedButtonTintColor, for: .normal)
                    btn.layer.borderColor = item.highlightedButtonTintColor.cgColor
                } else {
                    btn.setTitleColor(item.subtitlePlaceholderColor, for: .normal)
                    btn.layer.borderColor = item.subtitlePlaceholderColor.cgColor
                }
                btn.addTarget(self, action: #selector(rightActionTriggered), for: .touchUpInside)
            }
        } else {
            rightButtons.forEach { $0.removeFromSuperview() }
        }
        
        // left order number 左侧的序号
        if let item = item as? SettingOrderNumberItem {
            orderIcon.isHidden = false
            orderIcon.isEnabled = !item.isDisabled
            orderIcon.setTitle("\(item.orderNumber)", for: .normal)
            orderIcon.layer.cornerRadius = item.orderIconSize.width/2
            if orderIcon.isEnabled {
                let normalBgImage = UIImage(color: item.normalOrderColor, size: item.orderIconSize)?.roundingCorner(forRadius: orderIcon.layer.cornerRadius)
                orderIcon.setBackgroundImage(normalBgImage, for: .normal)
            } else {
                let disabledBgImage = UIImage(color: item.disabledOrderColor, size: item.orderIconSize)?.roundingCorner(forRadius: orderIcon.layer.cornerRadius)
                orderIcon.setBackgroundImage(disabledBgImage, for: .normal)
            }
            if !item.isDisabled, item.hidesSubtitleWhenEnabled {
                subtitleLabel.isHidden = true
            } else {
                subtitleLabel.isHidden = false
            }
        } else {
            subtitleLabel.isHidden = false
            orderIcon.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let item = item else { return }
        
        // customBgImageView
        // 注意此处不宜用contentView.frame, 因为有时contentView.frame != frame, 比如当有accessoryView的时候, contentView的宽度将会被减去accessoryView的宽度
        customBgImageView.frame = CGRect(x: item.backgroundImageInsets.left, y: item.backgroundImageInsets.top, width: frame.width - (item.backgroundImageInsets.left + item.backgroundImageInsets.right), height: frame.height - (item.backgroundImageInsets.top + item.backgroundImageInsets.bottom));
        
        // 测试得出 UITableViewCell 左侧和右侧默认的缩进
        let horizontalIndent: CGFloat = UIScreen.width == 320 ? 15 : 20
        let paddingBetweenDetailLabelAndAccessoryView: CGFloat = 3
        var detailTextLabelWidth = item.detailTextLabelFixedWidth
        var rightShiftedSpace = item.accessoryViewHorizontalShiftSpace
        if rightShiftedSpace == 0 {
            rightShiftedSpace = horizontalIndent - item.accessoryViewHorizontalIndent
        }
        let detailLabelX = customBgImageView.frame.width - horizontalIndent - item.detailTextLabelFixedWidth
        
        // imageViewNeedWidth
        var imageViewNeedWidth: CGFloat = 0
        if let imageView = imageView {
            if !item.iconName.isEmpty, imageView.frame.size.width > 0.1 {
                imageViewNeedWidth = horizontalIndent + imageView.frame.size.width
            }
        }
        
        // orderIcon
        var orderIconNeedsWidth: CGFloat = 0
        if let item = item as? SettingOrderNumberItem {
            orderIconNeedsWidth  = item.orderIconSize.width + item.horizontalOrderPadding
            orderIcon.frame = CGRect(x: item.horizontalOrderPadding, y: (customBgImageView.frame.height - item.orderIconSize.height)/2, width: item.orderIconSize.width, height: item.orderIconSize.height)
            // imageView右移到序号的右侧
            if let imageView = imageView, imageView.frame.width > 0.1 {
                imageView.frame.origin.x = orderIcon.frame.maxX + item.accessoryViewHorizontalIndent
                imageViewNeedWidth = item.accessoryViewHorizontalIndent + imageView.frame.width
            }
        }
        
        // titleLabel
        let titleLabelNeedSize = titleLabel.sizeThatFits(UIScreen.greatestSize)
        var titleLabelY: CGFloat = (customBgImageView.frame.height - titleLabelNeedSize.height)/2.0
        if item is SettingOpenDetailItem { // 使title不垂直居中
            titleLabelY = (SettingItem().supposedCellHeight - (item.backgroundImageInsets.top + item.backgroundImageInsets.bottom) - titleLabelNeedSize.height)/2.0
        }
        titleLabel.frame = CGRect(x: item.accessoryViewHorizontalIndent + orderIconNeedsWidth + imageViewNeedWidth, y: titleLabelY, width: titleLabelNeedSize.width, height: titleLabelNeedSize.height)
        
        // accessoryView右移一小段距离
        if let accessoryViewWidth = accessoryView?.frame.size.width, accessoryViewWidth >= 0.1 {
            accessoryView?.frame.origin.x += rightShiftedSpace
            var accessoryViewHeight: CGFloat = 0
            if let accessoryView = accessoryView {
                accessoryViewHeight = accessoryView.frame.size.height
            }
            var accessoryViewY: CGFloat = (frame.height - accessoryViewHeight)/2
            if item is SettingOpenDetailItem {
                accessoryViewY = (SettingItem().supposedCellHeight - accessoryViewHeight)/2
            }
            accessoryView?.frame.origin.y = accessoryViewY
            detailTextLabelWidth -= paddingBetweenDetailLabelAndAccessoryView + accessoryArrow.frame.width
        }
        
        // 固定宽度
        let subtitleLabelNeedSize = subtitleLabel.sizeThatFits(UIScreen.greatestSize)
        if subtitleLabelNeedSize.width >= 0.1, item.detailTextLabelFixedWidth >= 10 {
            let detailLabelHeight: CGFloat = subtitleLabelNeedSize.height
            var detailLabelY: CGFloat = (customBgImageView.frame.height - detailLabelHeight)/2.0
            if item is SettingOpenDetailItem { // 使subtitle不垂直居中
                detailLabelY = (SettingItem().supposedCellHeight - detailLabelHeight)/2.0
            }
            subtitleLabel.frame = CGRect(x: detailLabelX + rightShiftedSpace, y: detailLabelY, width: detailTextLabelWidth, height: detailLabelHeight)
        }
        
        // sectionTitleLabel 段头标题
        if sectionTitleLabel.superview != nil && item is SettingSectionHeaderItem {
            var sectionTitleLabelX = horizontalIndent
            let sectionTitleLabelSize = sectionTitleLabel.sizeThatFits(UIScreen.greatestSize)
            let sectionTitleLabelY = (customBgImageView.frame.height - sectionTitleLabelSize.height)/2.0
            if (imageView?.frame.width).noneNull >= 0.1 {
                sectionTitleLabelX = (imageView?.frame.maxX).noneNull + 3
            }
            sectionTitleLabel.frame = CGRect(x: sectionTitleLabelX, y: sectionTitleLabelY, width: sectionTitleLabelSize.width, height: sectionTitleLabelSize.height)
            // 实践中发现cell中自带的imageView有时不会垂直居中, 故矫正如下
            if let imageView = imageView {
                let imageViewY = (frame.height - imageView.frame.height)/2.0
                imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageViewY, width: imageView.frame.width, height: imageView.frame.height)
            }
        }
        
        // textfield 输入框
        if textField.superview != nil, let item = item as? SettingTextFieldItem {
            var textFieldWidth           = detailTextLabelWidth
            let textFieldHeight: CGFloat = 28.0
            var textFieldX               = detailLabelX + rightShiftedSpace
            let textFieldY: CGFloat      = (customBgImageView.frame.height - textFieldHeight)/2.0
            if item.isCoverTitle {
                textFieldX     = horizontalIndent - 5
                textFieldWidth = customBgImageView.frame.width - textFieldX * 2
            }
            textField.frame = CGRect(x: textFieldX, y: textFieldY, width: textFieldWidth, height: textFieldHeight)
        }
        
        // fullTextLabel
        if fullTextLabel.superview != nil, let item = item as? SettingFullTextItem, !(item is SettingTextViewItem) {
            let fullTextBgViewWidth = customBgImageView.frame.width - SettingFullTextItem.horizontalIndent * 2.0
            fullTextBgView.frame = CGRect(x: SettingFullTextItem.horizontalIndent, y: item.cellInsets.top, width: fullTextBgViewWidth, height: item.textHeight)
            let fullTextLabelX: CGFloat = 10
            let fullTextLabelY: CGFloat = 10
            var fullTextLabelNeedHeight = fullTextLabel.sizeThatFits(CGSize(width: fullTextBgViewWidth - 2 * fullTextLabelX, height: CGFloat.greatestFiniteMagnitude)).height
            let fullTextLabelMaxHeight = item.textHeight - 2 * fullTextLabelY
            if fullTextLabelNeedHeight >= fullTextLabelMaxHeight {
                fullTextLabelNeedHeight = fullTextLabelMaxHeight
            }
            fullTextLabel.frame = CGRect(x: fullTextLabelX, y: fullTextLabelY, width: fullTextBgViewWidth - 2 * fullTextLabelX, height: fullTextLabelNeedHeight)
        }
        
        // textView
        if textView.superview != nil, let item = item as? SettingTextViewItem {
            let textViewX     = SettingTextViewItem.horizontalIndent
            let textViewY     = item.cellInsets.top
            let textViewWidth = customBgImageView.frame.width - textViewX * 2
            textView.frame    = CGRect(x: textViewX, y: textViewY, width: textViewWidth, height: item.textHeight)
        }
        
        
        // thumbnials grid 缩略图网格
        if thumbnialImageViews.first?.superview != nil, let item = item as? SettingImageGridItem {
            for index in 0..<thumbnialImageViews.count {
                let imageView  = thumbnialImageViews[index]
                let imageViewX = SettingImageGridItem.horizontalIndent + CGFloat(index % item.maxAmountInOneLine) * (item.imageViewSize.width + item.interitemPadding)
                let imageViewY = item.cellInsets.top + CGFloat(index / item.maxAmountInOneLine) * (item.imageViewSize.height + item.linePadding)
                imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: item.imageViewSize.width, height: item.imageViewSize.height)
            }
        }
        
        // right action buttons
        if let item = item as? SettingRightActionsItem, rightButtons.first?.superview != nil {
            for index in 0..<rightButtons.count {
                let btn  = rightButtons[index]
                let btnY = (customBgImageView.frame.height - item.buttonSize.height)/2
                let btnX = customBgImageView.frame.width - item.accessoryViewHorizontalIndent - CGFloat(index + 1) * item.buttonSize.width - CGFloat(index) * item.interitemPadding
                btn.frame = CGRect(x: btnX, y: btnY, width: item.buttonSize.width, height: item.buttonSize.height)
            }
        }
    }
}

//MARK: - Handle Events
extension SettingCell: UITextFieldDelegate, UITextViewDelegate {
    @objc fileprivate func textFieldTextDidChange() {
        inputViewDidChangeText = true
        guard let item = item else { return }
        if item.isKind(of: SettingTextFieldItem.self) {
            item.subtitle = textField.text
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputViewDidChangeText = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let item = item as? SettingTextFieldItem else { return true }
        if string.count > 0, let text = textField.text, text.count >= item.maxCharactersAllowed {
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        item?.subtitle = textView.text
    }
    
    @objc fileprivate func rightActionTriggered(sender: UIButton) {
        if let item = item as? SettingRightActionsItem {
            item.buttonClicked?(sender.tag, sender)
        }
    }
}
