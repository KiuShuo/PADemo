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
    /// 当设置过tableView.rowHeight时 且使用tableDelegater自动计算cell高度时，务必将该值设为true
    var isRowHeight: Bool = false
    /// cell的注册方法 nib或class
    var isRegisterByClass: Bool = false
    /// cell的类型名
    var classType: AnyClass?
    /// cell所需要的业务数据 复用比较多的cell中包含一个自己的CellDataModelClass，外部使用的地方统一生成该类型的Model
    var dataModel: PAModelBaseProtocol? = nil
    var isEnforceFrameLayout: Bool = false
    var didSelecte: ((PACellModel) -> Void)? = nil
    var isCacheCellHeight: Bool = true
    
    init(identifier: String, height: CGFloat, isRegisterByClass: Bool = false, classType: AnyClass? = nil) {
        self.identifier = identifier
        self.height = height
        self.isRegisterByClass = isRegisterByClass
        self.classType = classType
    }
    
    init(classType: AnyClass, dataModel: PAModelBaseProtocol? = nil, height: CGFloat = -1) {
        self.classType = classType
        if Bundle.main.path(forResource: String(describing: classType), ofType: "nib") != nil {
            self.isRegisterByClass = false
        } else {
            self.isRegisterByClass = true
        }
        self.identifier = String(describing: classType)
        self.dataModel = dataModel
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
    var headerFooterView: UITableViewHeaderFooterView?
    var headerFooterViewName: String?
    var identifier: String
    var height: CGFloat = -1
    var isRegisterByClass: Bool = false
    var classType: AnyClass?
    
    init(identifier: String, height: CGFloat = -1, isRegisterByClass: Bool = false, classType: AnyClass? = nil) {
        self.identifier = identifier
        self.height = height
        self.isRegisterByClass = isRegisterByClass
        self.classType = classType
    }
}

struct PASectionModel {
    var headerViewModel: PAHeaderFooterViewModel?
    var footerViewModel: PAHeaderFooterViewModel?
    var cellModelArr: [PACellModel] = []
    var sectionName: String?
    
    init() {}
    
    init(cellModelArr: [PACellModel]) {
        self.cellModelArr = cellModelArr
    }
    
    init(cellClassType: AnyClass, dataModels: [PAModelBaseProtocol]) {
        let cellModels = dataModels.map { PACellModel(classType: cellClassType, dataModel: $0) }
        self.init(cellModelArr: cellModels)
    }
    
    init(cellModel: PACellModel, dataModels: [PAModelBaseProtocol]) {
        var aCellModel = cellModel
        let cellModels = dataModels.map { dataModel -> PACellModel in
            aCellModel.dataModel = dataModel
            return aCellModel
        }
        self.init(cellModelArr: cellModels)
    }
    
    static func searchSection(with sectionName: String, sectionModels: [PASectionModel]) -> PASectionModel? {
        let filterResults = sectionModels.filter { sectionModel -> Bool in
            return sectionModel.sectionName == sectionName
        }
        return filterResults.first
    }
    
    subscript(indexPath: IndexPath) -> PACellModel {
        return cellModelArr[indexPath.row]
    }
    
}
