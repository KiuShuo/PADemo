//
//  PATableViewModel.swift
//  wanjia
//
//  Created by shuoliu on 16/5/3.
//  Copyright © 2016年 pingan. All rights reserved.
//

import Foundation
import UIKit

struct PACellModel {
    var cellName: String?
    var identifier: String
    var height: CGFloat
    var isRegisterByClass: Bool = false
    var classType: AnyClass?
    var dataModel: Any? = nil
    
    init(identifier: String, height: CGFloat, isRegisterByClass: Bool = false, classType: AnyClass? = nil) {
        self.identifier = identifier
        self.height = height
        self.isRegisterByClass = isRegisterByClass
        self.classType = classType
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

struct PASectionModel {
    //    var headerTitle: String?
    //    var footerTitle: String?
    //    var headerView: UIView?
    //    var footerView: UIView?
    //    var headerHeight: CGFloat?
    //    var footerHeight: CGFloat?
    var headerViewModel: PAHeaderFooterViewModel?
    var footerViewModel: PAHeaderFooterViewModel?
    var cellModelArr: [PACellModel] = []
    var sectionName: String?
    
    static func searchSection(with sectionName: String, sectionModels: [PASectionModel]) -> PASectionModel? {
        for sectionModel in sectionModels {
            if sectionName == sectionModel.sectionName {
                return sectionModel
            }
        }
        return nil
    }
    
}



class PATableViewModel {
    
    static let tableviewCellDefaultHeight: CGFloat = 44.0
    
    static func getSectionModel(_ cellModels: [PACellModel], sectionName: String? = nil, headerViewModel: PAHeaderFooterViewModel? = nil, footerViewModel: PAHeaderFooterViewModel? = nil) -> PASectionModel {
        var sectionModel = PASectionModel()
        sectionModel.sectionName = sectionName
        sectionModel.cellModelArr = cellModels
        sectionModel.headerViewModel = headerViewModel
        sectionModel.footerViewModel = footerViewModel
        return sectionModel
    }
    
    static func dequeueReusableCellWithCellModel(_ cellModel: PACellModel, tableView: UITableView) -> UITableViewCell {
        let identifier = cellModel.identifier
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            registCellWithCellModels([cellModel], tableView: tableView)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        }
        return cell!
    }
    
    static func registCellWithCellModels(_ cellModels: [PACellModel], tableView: UITableView) {
        cellModels.forEach { (cellModel) in
            let identifier = cellModel.identifier
            if cellModel.isRegisterByClass {
                tableView.register(cellModel.classType, forCellReuseIdentifier: identifier)
            } else {
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            }
        }
    }
    
    static func dequeueReusableHeaderFooterViewWithHeaderFooterModel(_ headerFooterViewModel: PAHeaderFooterViewModel, tableView: UITableView) -> UITableViewHeaderFooterView {
        let identifier = headerFooterViewModel.identifier
        var headerFooterView: UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if headerFooterView == nil {
            if headerFooterViewModel.isRegisterByClass {
                tableView.register(headerFooterViewModel.classType, forHeaderFooterViewReuseIdentifier: identifier)
            } else {
                tableView.register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
            }
            headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        }
        return headerFooterView!
    }
    
}

class PATableViewDelegate: NSObject,  UITableViewDelegate, UITableViewDataSource {
    
    var sectionModels: [PASectionModel] = []
    var didSelectCell: ((_ indexPath: IndexPath) -> Void)?
    var configureCell: ((_ cell: UITableViewCell, _ indexPath: IndexPath, _ cellModel: PACellModel) -> Void)?
    var cellHeight: ((_ tableView: UITableView, _ indexPath: IndexPath, _ cellModel: PACellModel) -> CGFloat)?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModels[section].cellModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = sectionModels[indexPath.section].cellModelArr[indexPath.row]
        let cell = PATableViewModel.dequeueReusableCellWithCellModel(cellModel, tableView: tableView)
        if let configureCell = configureCell {
            configureCell(cell, indexPath, cellModel)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = sectionModels[indexPath.section].cellModelArr[indexPath.row]
        if let cellHeight = cellHeight {
            return cellHeight(tableView, indexPath, cellModel)
        }
        return cellModel.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let didSelectCell = didSelectCell {
            didSelectCell(indexPath)
        }
    }
    
}

// 常用扩展
extension PATableViewModel {
    
    static func getSectionModel(cellModelTupleArr: (PACellModel, Int)...) -> PASectionModel {
        var cellModels: [PACellModel] = []
        cellModelTupleArr.forEach { (cellModelTuple) in
            let (cellModel, cellCount) = (cellModelTuple.0, cellModelTuple.1)
            cellModels += [PACellModel](repeating: cellModel, count: cellCount)
        }
        let sectionModel = PATableViewModel.getSectionModel(cellModels)
        return sectionModel
    }
    
}
