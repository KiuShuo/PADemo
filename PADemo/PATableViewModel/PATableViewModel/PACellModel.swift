//
//  PACellModel.swift
//  PADemo
//
//  Created by shuo on 2017/5/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation

struct PACellModel {
    /// 用以区分相同标示符的cell
    var cellName: String?
    /// 重用标示符，默认情况下和类名相同(建议使用默认状态)
    var identifier: String
    /// 默认高度为-1时，由PATableDelegater内部计算高度，适用于约束加完全的cell
    var height: CGFloat = -1
    /// cell的注册方法 nib或class
    var isRegisterByClass: Bool = false
    /// cell的类型名
    var classType: AnyClass?
    /// cell所需要的业务数据 复用比较多的cell中包含一个自己的CellDataModelClass，外部使用的地方统一生成该类型的Model
    var dataModel: PAModelBaseProtocol? = nil
    var isEnforceFrameLayout: Bool = false
    var didSelecte: ((PACellModel) -> Void)? = nil
    
    /// - Parameters:
    ///   - identifier: 重用标示符
    ///   - height: cell高度
    ///   - isRegisterByClass: 是否为xib创建
    ///   - classType: cell的类型
    init(identifier: String, height: CGFloat, isRegisterByClass: Bool = false, classType: AnyClass? = nil) {
        self.identifier = identifier
        self.height = height
        self.isRegisterByClass = isRegisterByClass
        self.classType = classType
    }
    
    /// - Parameters:
    ///   - identifier: 重用标示符 当其与String(describing: classType)相同时，可设置为nil
    ///   - classType: cell的类型
    init(classType: AnyClass, identifier: String? = nil, height: CGFloat = -1) {
        self.classType = classType
        if Bundle.main.path(forResource: String(describing: classType), ofType: "nib") != nil {
            self.isRegisterByClass = false
        } else {
            self.isRegisterByClass = true
        }
        if let identifier = identifier {
            self.identifier = identifier
        } else {
            self.identifier = String(describing: classType)
        }
        self.height = height
    }
    
    init(classType: AnyClass, dataModel: PAModelBaseProtocol? = nil, didSelecte: @escaping ((PACellModel) -> Void)) {
        self.classType = classType
        if Bundle.main.path(forResource: String(describing: classType), ofType: "nib") != nil {
            self.isRegisterByClass = false
        } else {
            self.isRegisterByClass = true
        }
        self.identifier = String(describing: classType)
        self.dataModel = dataModel
        self.didSelecte = didSelecte
    }
}

protocol PATableViewCellProtocol {
    /// 为服从协议的cell添加数据源
    var dataModel: PAModelBaseProtocol? { get set }
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

struct PASectionModel {
    //    var headerTitle: String?
    //    var footerTitle: String?
    //    var headerView: UIView?
    //    var footerView: UIView?
    //    var headerHeight: CGFloat?
    //    var footerHeight: CGFloat?
    var headerViewModel: PAHeaderFooterViewModel? = nil
    var footerViewModel: PAHeaderFooterViewModel? = nil
    var cellModelArr: [PACellModel] = []
    var sectionName: String? = nil
    
    init(cellModelArr: [PACellModel]) {
        self.cellModelArr = cellModelArr
    }
    
    static func searchSection(with sectionName: String, sectionModels: [PASectionModel]) -> PASectionModel? {
        for sectionModel in sectionModels {
            if sectionName == sectionModel.sectionName {
                return sectionModel
            }
        }
        return nil
    }
    
}
