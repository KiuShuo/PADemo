//
//  PATableViewModel.swift
//  wanjia
//
//  Created by shuoliu on 16/5/3.
//  Copyright © 2016年 pingan. All rights reserved.
//

import Foundation

extension UITableView {
    
    func dequeueReusableCellWithCellModel(_ cellModel: PACellModel) -> UITableViewCell {
        let identifier = cellModel.identifier
        var cell: UITableViewCell? = dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            registCellWithCellModels([cellModel])
            cell = dequeueReusableCell(withIdentifier: identifier)
        }
        return cell!
    }
    
    func registCellWithCellModels(_ cellModels: [PACellModel]) {
        cellModels.forEach { (cellModel) in
            let identifier = cellModel.identifier
            if cellModel.isRegisterByClass {
                register(cellModel.classType, forCellReuseIdentifier: identifier)
            } else {
                register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            }
        }
    }
    
    func dequeueReusableHeaderFooterViewWithHeaderFooterModel(_ headerFooterViewModel: PAHeaderFooterViewModel) -> UITableViewHeaderFooterView {
        let identifier = headerFooterViewModel.identifier
        var headerFooterView: UITableViewHeaderFooterView? = dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if headerFooterView == nil {
            if headerFooterViewModel.isRegisterByClass {
                register(headerFooterViewModel.classType, forHeaderFooterViewReuseIdentifier: identifier)
            } else {
                register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
            }
            headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: identifier)
        }
        return headerFooterView!
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
