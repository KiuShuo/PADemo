//
//  PACellModel.swift
//  PADemo
//
//  Created by shuo on 2017/5/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation
import UIKit

protocol PATableViewCellProtocol {
    var dataModel: Any? { get set }
}

//extension UITableViewCell {
//    
//    static var kDataModel = "dataModel"
//    
//    var dataModel: Any? {
//        get {
//            return objc_getAssociatedObject(self, &UITableViewCell.kDataModel)
//        }
//        set {
//            objc_setAssociatedObject(self, &UITableViewCell.kDataModel, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//}


struct PACellModel {
    var cellName: String?   /// 用以区分相同标示符的cell
    var identifier: String /// 重用标示符，默认情况下和类名相同
    var height: CGFloat = -1
    var isRegisterByClass: Bool = false
    var classType: AnyClass?
    var dataModel: Any? = nil
    
    init(identifier: String, height: CGFloat, isRegisterByClass: Bool = false, classType: AnyClass? = nil) {
        self.identifier = identifier
        self.height = height
        self.isRegisterByClass = isRegisterByClass
        self.classType = classType
    }
    
    init(identifier: String?, classType: AnyClass) {
        if let identifier = identifier {
            self.identifier = identifier
        } else {
            self.identifier = String(describing: classType)
        }
        self.classType = classType
        if Bundle.main.path(forResource: String(describing: classType), ofType: "nib") != nil {
            self.isRegisterByClass = true
        } 
    }
}


struct PAHeaderFooterViewModel {
    var headerFooterViewName: String?
    var identifier: String
    var height: CGFloat
    var isRegisterByClass: Bool = false
    var classType: AnyClass?
    
    init(identifier: String, height: CGFloat, isRegisterByClass: Bool = false, classType: AnyClass? = nil) {
        self.identifier = identifier
        self.height = height
        self.isRegisterByClass = isRegisterByClass
        self.classType = classType
    }
}
