//
//  PATableViewModel.swift
//  feng
//
//  Created by shuoliu on 16/5/3.
//  Copyright © 2016年 shuo. All rights reserved.
//   未来优化参考方案 https://github.com/fastred/ConfigurableTableViewController

import Foundation

extension UITableView {
    
    private static var hadRegistedIdentifiersKey = "hadRegistedIdentifiersKey"
    private var hadRegistedIdentifiers: [String] {
        get {
            if let hadResistedIdentifiers = objc_getAssociatedObject(self, &UITableView.hadRegistedIdentifiersKey) as? [String] {
                return hadResistedIdentifiers
            }
            return [String]()
        }
        set {
            objc_setAssociatedObject(self, &UITableView.hadRegistedIdentifiersKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func dequeueReusableCell(withCellModel cellModel: PACellModel) -> UITableViewCell {
        let identifier = cellModel.identifier
        var cell: UITableViewCell? = dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            registCell(withCellModels: [cellModel])
            cell = dequeueReusableCell(withIdentifier: identifier)
        }
        return cell!
    }
    
    func registCell(withCellModels cellModels: [PACellModel]) {
        for cellModel in cellModels {
            let identifier = cellModel.identifier
            if hadRegistedIdentifiers.contains(identifier) {
                continue
            }
            if !cellModel.isNeedRegister {
                continue
            }
            if cellModel.isRegisterByClass {
                register(cellModel.classType, forCellReuseIdentifier: identifier)
            } else {
                register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            }
            hadRegistedIdentifiers.append(identifier)
        }
    }
    
    func dequeueReusableHeaderFooterView(withHeaderFooterModel headerFooterViewModel: PAHeaderFooterViewModel) -> UIView {
        let identifier = headerFooterViewModel.identifier
        var headerFooterView: UIView? = dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if headerFooterView == nil {
            if headerFooterViewModel.headerFooterView != nil {
                headerFooterView = headerFooterViewModel.headerFooterView
            } else {
                if headerFooterViewModel.isRegisterByClass {
                    register(headerFooterViewModel.classType, forHeaderFooterViewReuseIdentifier: identifier)
                } else {
                    register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
                }
                headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: identifier)
            }
        }
        return headerFooterView!
    }
    
    func generateSectionModel(dataModels: [PAModelBaseProtocol], map: Any) {
        
    }
    
}

class PATableViewModel {
    
    static func getSectionModel(_ cellModels: [PACellModel], sectionName: String? = nil, headerViewModel: PAHeaderFooterViewModel? = nil, footerViewModel: PAHeaderFooterViewModel? = nil) -> PASectionModel {
        var sectionModel = PASectionModel(cellModelArr: cellModels)
        sectionModel.sectionName = sectionName
        sectionModel.headerViewModel = headerViewModel
        sectionModel.footerViewModel = footerViewModel
        return sectionModel
    }
    
    static func getSectionModel(cellModelTupleArr: (PACellModel, Int)...) -> PASectionModel {
        var cellModels: [PACellModel] = []
        cellModelTupleArr.forEach { cellModelTuple in
            let (cellModel, cellCount) = (cellModelTuple.0, cellModelTuple.1)
            cellModels += [PACellModel](repeating: cellModel, count: cellCount)
        }
        let sectionModel = PATableViewModel.getSectionModel(cellModels)
        return sectionModel
    }
    
    static func tableViewCellClass(with name: String) -> UITableViewCell.Type? {
        if let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
            if let tableViewCellClass = NSClassFromString(nameSpace + "." + name) as? UITableViewCell.Type {
                return tableViewCellClass
            }
        }
        return nil
    }
    
}

// future test...

extension PATableDelegater {
    // 生成一个sectionModel
    
    // 生成一组sectionModels
    
    func generateSectionModel(dataModels: [PAModelBaseProtocol], map: Any) {
        
    }
    
}
