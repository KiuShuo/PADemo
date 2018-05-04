//
//  SettingItems.swift
//  feng
//
//  Created by luozhijun on 2016/11/23.
//  Copyright © 2017年 shuo. All rights reserved.
//

typealias SettingItemAction = (SettingItem) -> Void
//import WJExtension
//MARK: - SettingItem

/** 设置、表单界面中列表单元格的基本模型. 对于只要是使用自带控件、内部结构简单的cell有一定的通用性 */
class SettingItem: NSObject, NSCopying {
    
    var iconName = ""
    var title              : String?
    var subtitle           : String?
    var attributedSubtitle : NSAttributedString?
    var subtitlePlaceholder: String?
    
    var indexPath: IndexPath?
    /// cell是否可选中, 即didSelect代理方法是否响应
    var enable                   = false
    var selectionStyle           = UITableViewCellSelectionStyle.default
    /// cell本身或其子视图是否能接受事件
    var isUserInteractionEnabled = true
    var backgroundColor          = UIColor.white
    var selectedBackgroundColor: UIColor? = nil
    
    var name = ""
    
    var backgroundImageInsets: UIEdgeInsets = UIEdgeInsets.zero
    var backgroundImage: UIImage?  = nil
    var highlightedBackgroundImage: UIImage? = nil
    
    var titleColor                   = UIColor.black
    var titleFont                    = UIFont.systemFont(ofSize: 15)
    var disabledTitelColor           = UIColor.lightGray
    var subtitleColor                = UIColor.black
    var subtitleFont                 = UIFont.systemFont(ofSize: 14)
    var subtitleAlignment            = NSTextAlignment.right
    var subtitlePlaceholderColor     = UIColor.lightGray
    var subtitlePlaceholderFont      = UIFont.systemFont(ofSize: 14)
    var subtitlePlaceholderAlignment = NSTextAlignment.right
    
    /// 保持320宽度的水平缩进, 比4.7寸以上屏幕上的UITableViewCelld默认的水平缩进小5
    var accessoryViewHorizontalIndent: CGFloat = 15
    var accessoryViewHorizontalShiftSpace: CGFloat = 0
    
    var detailTextLabelFixedWidth: CGFloat {
        let scaleRatio = UIScreen.width/320.0
        if UIScreen.width == 320 {
            return 200
        } else {
            return 210 * scaleRatio
        }
    }
    
    var supposedCellHeight: CGFloat {
        return 44
    }
    
    /** 是否必填, 是的话会在cell标题开端加上＊标识 */
    var required = false
    var shouldAddAsteriskMarkWhenRequired = true
    
    var action: SettingItemAction?
    
    required init(iconName: String? = nil, title: String? = nil, subtitle: String? = nil, subtitlePlaceholder: String? = nil, required: Bool = false, enable: Bool = false, isUserInteractionEnabled: Bool = true) {
        super.init()
        self.iconName                 = iconName.noneNull
        self.title                    = title
        self.subtitle                 = subtitle
        self.subtitlePlaceholder      = subtitlePlaceholder
        self.required                 = required
        self.enable                   = enable
        self.isUserInteractionEnabled = isUserInteractionEnabled
        if enable == false {
            self.selectionStyle = .none
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let mirror = SettingItem(iconName: iconName, title: title, subtitle: subtitle, subtitlePlaceholder: subtitlePlaceholder, required: required, enable: enable, isUserInteractionEnabled: isUserInteractionEnabled)
        mirror.attributedSubtitle            = attributedSubtitle
        mirror.selectionStyle                = selectionStyle
        mirror.backgroundColor               = backgroundColor
        mirror.indexPath                     = indexPath
        mirror.titleFont                     = titleFont
        mirror.titleColor                    = titleColor
        mirror.subtitleFont                  = subtitleFont
        mirror.subtitleColor                 = subtitleColor
        mirror.subtitleAlignment             = subtitleAlignment
        mirror.disabledTitelColor            = disabledTitelColor
        mirror.subtitlePlaceholderFont       = subtitlePlaceholderFont
        mirror.subtitlePlaceholderColor      = subtitlePlaceholderColor
        mirror.subtitlePlaceholderAlignment  = subtitlePlaceholderAlignment
        mirror.accessoryViewHorizontalIndent = accessoryViewHorizontalIndent
        mirror.action                        = action
        return mirror
    }
}

/** 设置、表单界面中带箭头的单元格模型 */
class SettingArrowItem: SettingItem {
    /** 跳转目标控制器的类名 */
    var destinationVcClass: AnyClass?
    var isArrowHidden = false
}

/** 设置、表单界面中, cell右侧是一个打勾图标的单元格模型 */
class SettingCheckmarkItem: SettingItem {
    var isChecked = false
}

/** 设置、表单界面中把cell用作段头的单元格模型 */
class SettingSectionHeaderItem: SettingItem {
    var headerIconName = ""
    override var supposedCellHeight: CGFloat {
        return 36
    }
}

/** 设置、表单界面, 含TextField的单元格模型, 一般是在右侧 */
class SettingTextFieldItem: SettingItem {
    // 是否覆盖cell的标题
    var isCoverTitle = false
    var keyboardType = UIKeyboardType.default
    var maxCharactersAllowed = Int.max
}

/** 设置、表单界面, 文本几乎占据整个cell的空间  */
class SettingFullTextItem: SettingItem {
    static var horizontalIndent: CGFloat = UIScreen.width == 320 ? 10 : 15
    var textHeight: CGFloat = 100.0
    var cellInsets = UIEdgeInsets(top: 12, left: horizontalIndent, bottom: 12, right: horizontalIndent)
    override var supposedCellHeight: CGFloat {
        return textHeight + cellInsets.top + cellInsets.bottom
    }
}

/** 设置、表单界面, 含TextView的单元格模型, textView几乎占据整个cell的空间 */
class SettingTextViewItem: SettingFullTextItem {
    var textViewEnable = true
    var keyboardType   = UIKeyboardType.default
    var textViewBackgroundColor: UIColor     = UIColor.paLightGray
    var placeholderX: CGFloat = 10
    var placeholderY: CGFloat = 10
}

/** 设置、表单界面中, 由多张图片组成的网格式排列的单元格模型 */
class SettingImageGridItem: SettingItem {
    var images: [PACompoundImage] {
        set {
            unroundedImages = newValue
            let usingNewVaule = newValue.map { (compoundImage) -> PACompoundImage in
                if let image = compoundImage.image {
                    // PACompoundImage是类, 不会发生拷贝, 此处为了不影响源数据, 一定要创建新的实例
                    let replacingItem = PACompoundImage()
                    replacingItem.urlString = compoundImage.urlString
                    replacingItem.image = image.roundingCorner(forRadius: imageCornerRadius, sizeToFit: imageViewSize)
                    replacingItem.fullScreenImage = compoundImage.fullScreenImage
                    return replacingItem
                }
                return compoundImage
            }
            internalImages = usingNewVaule
        } get {
            return internalImages
        }
    }
    /// 未经裁剪的图片
    internal var unroundedImages  = [PACompoundImage]()
    internal var internalImages   = [PACompoundImage]()
    var maxAmountInOneLine         = 4
    var imageCornerRadius: CGFloat = 4
    var imageViewContentMode       = UIViewContentMode.scaleAspectFill
    var imageViewSize: CGSize {
        if UIDevice.isIPHONE_4_7 || UIDevice.isIPHONE_X {
            return CGSize(width: 80, height: 80)
        } else if UIDevice.isIPHONE_5_5 {
            return CGSize(width: 90, height: 90)
        } else {
            return CGSize(width: 70, height: 70)
        }
    }
    
    /// 比UITableViewCelld默认的水平缩进小5
    static var horizontalIndent: CGFloat = UIScreen.width == 320 ? 10 : 15
    var cellInsets = UIEdgeInsets(top: 12, left: horizontalIndent, bottom: 12, right: horizontalIndent)
    /// 存储计算好的相邻间距(interitemPadding), 防止调用计算属性interitemPadding时, 每次都要计算.
    private var storedInteritemPadding: CGFloat = 0
    var interitemPadding: CGFloat {
        if storedInteritemPadding <= 0 {
            storedInteritemPadding = (UIScreen.width - 2 * SettingImageGridItem.horizontalIndent - CGFloat(maxAmountInOneLine) * imageViewSize.width) / CGFloat(maxAmountInOneLine - 1)
        }
        return storedInteritemPadding
    }
    var linePadding: CGFloat {
        return interitemPadding
    }
    
    override var supposedCellHeight: CGFloat {
        guard images.count > 0 else { return 0 }
        let lineAmount = CGFloat(Int((CGFloat(images.count) - 0.5) / CGFloat(maxAmountInOneLine) + 1.0))
        let sumOfLinePaddings = (lineAmount - 1) > 0 ? CGFloat(lineAmount - 1) * linePadding : 0
        return cellInsets.top + cellInsets.bottom + lineAmount * imageViewSize.height + sumOfLinePaddings
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let mirror = super.copy(with: zone) as? SettingImageGridItem else { return self }
        mirror.maxAmountInOneLine   = maxAmountInOneLine
        mirror.imageCornerRadius    = imageCornerRadius
        mirror.imageViewContentMode = imageViewContentMode
        mirror.internalImages       = internalImages
        mirror.cellInsets           = cellInsets
        return mirror
    }
}

/** 设置、表单界面中, 在右侧含基本的删除、添加按钮的单元格模型 */
class SettingRightActionsItem: SettingItem {
    var buttonClicked: ((Int, UIButton) -> Swift.Void)?
    var buttonTitles               = [String]()
    var buttonSize                 = CGSize(width: 70, height: 26)
    var highlightedButtonIndex     = 0
    var highlightedButtonTintColor = UIColor.paOrange
    var interitemPadding: CGFloat  = 20
    // 字体使用父类的subtitleFont, 非高亮button的字体颜色使用父类的subtitlePlaceholderColor
}

/** 设置、表单界面中, 点击cell弹出详情的单元格模型 */
class SettingOpenDetailItem: SettingArrowItem {
    var isOpen = false
    var detailViewSize: CGSize = .zero
    override var supposedCellHeight: CGFloat {
        if isOpen {
            return super.supposedCellHeight + detailViewSize.height
        } else {
            return super.supposedCellHeight
        }
    }
}

/** 设置、表单界面中, 左侧有序号的cell模型 */
class SettingOrderNumberItem: SettingArrowItem {
    var orderNumber: Int = 0
    var isDisabled: Bool = false
    var orderIconSize: CGSize = CGSize(width: 24, height: 24)
    var horizontalOrderPadding: CGFloat = 15
    var normalOrderColor: UIColor = UIColor.orange
    var disabledOrderColor: UIColor = UIColor.lightGray
    var hidesSubtitleWhenEnabled = true
    
    override var supposedCellHeight: CGFloat {
        return 60;
    }
}

//MARK: - SettingGroup
/** 设置、表单界面中列表单元格的分组模型 */
class SettingGroup : NSObject, NSCopying {
    var items = [SettingItem]()
    
    var headerIconName: String?
    var headerTitle: String?
    var headerTitleFont  = UIFont.systemFont(ofSize: 15)
    var headerTitleColor = UIColor.black
    
    var footerIconName: String?
    var footerTitle: String?
    var footerTitleFont  = UIFont.systemFont(ofSize: 15)
    var footerTitleColor = UIColor.black
    
    func copy(with zone: NSZone? = nil) -> Any {
        let mirror = SettingGroup()
        mirror.items = items.map({ (originalItem) -> SettingItem in
            return originalItem.copy() as! SettingItem
        })
        mirror.headerIconName   = headerIconName
        mirror.headerTitle      = headerTitle
        mirror.headerTitleFont  = headerTitleFont
        mirror.headerTitleColor = headerTitleColor

        mirror.footerIconName   = footerIconName
        mirror.footerTitle      = footerTitle
        mirror.footerTitleFont  = footerTitleFont
        mirror.footerTitleColor = footerTitleColor
        return mirror
    }
}


