//
//  PATableDelegater.swift
//  PADemo
//
//  Created by shuo on 2017/5/27.
//  Copyright © 2017年 shuo. All rights reserved.

import Foundation
import UITableView_FDTemplateLayoutCell

class PATableDelegater: NSObject {
    
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    fileprivate var registedIdentifiers: [String] = []
    
    /// 外部需传入的数据源
    var sectionModels: [PASectionModel] = []
    
    /// 代理函数
    typealias PATableCellForRowBlock = (tableView: UITableView, indexPath: IndexPath, cell: UITableViewCell, cellModel: PACellModel)
    typealias PATableDelegateConfigBlock = (tableView: UITableView, indexPath: IndexPath, cellModel: PACellModel)
    
    var configureCell: ((_ tableViewBlockParam: PATableCellForRowBlock) -> Void)?
    var didSelectCell: ((_ tableViewBlockParam: PATableDelegateConfigBlock) -> Void)?
    var cellHeight: ((_ tableViewBlockParam: PATableDelegateConfigBlock) -> CGFloat)?
    
    func cellModel(_ indexPath: IndexPath) -> PACellModel {
        return sectionModels[indexPath.section][indexPath]
    }
    
}

extension PATableDelegater: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModels[section].cellModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.cellModel(indexPath)
        let cell = tableView.dequeueReusableCell(withCellModel: cellModel)
        if let configureCell = configureCell {
            let tableCellForRowBlock: PATableCellForRowBlock = (tableView, indexPath, cell, cellModel)
            configureCell(tableCellForRowBlock)
        } else {
            if var aCell = cell as? PATableViewCellProtocol {
                aCell.dataModel = cellModel.dataModel
            }
        }
        return cell
    }
    
}

extension PATableDelegater: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = self.cellModel(indexPath)
        if let cellHeight = cellHeight {
            let tableDelegateConfigBlock: PATableDelegateConfigBlock = (tableView, indexPath, cellModel)
            return cellHeight(tableDelegateConfigBlock)
        } else if cellModel.height > -1 {
            return cellModel.height
        } else if tableView.rowHeight > -1 {
            return tableView.rowHeight
        }
        tableView.registCell(withCellModels: [cellModel])
        let height =  tableView.fd_heightForCell(withIdentifier: cellModel.identifier, cacheBy: indexPath, configuration: { cell in
            (cell as? UITableViewCell)?.bounds.size.width = tableView.bounds.width
            (cell as? UITableViewCell)?.fd_enforceFrameLayout = cellModel.isEnforceFrameLayout
            if var aCell = cell as? PATableViewCellProtocol {
                aCell.dataModel = cellModel.dataModel
            }
        })
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = self.cellModel(indexPath)
        if let didSelecte = cellModel.didSelecte {
            didSelecte(cellModel)
        }
        if let didSelectCell = didSelectCell {
            let cellModel = sectionModels[indexPath.section].cellModelArr[indexPath.row]
            let tableDelegateConfigBlock: PATableDelegateConfigBlock = (tableView, indexPath, cellModel)
            didSelectCell(tableDelegateConfigBlock)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = sectionModels[section]
        guard let headerViewModel = sectionModel.headerViewModel else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withHeaderFooterModel: headerViewModel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = sectionModels[section]
        guard let footerViewModel = sectionModel.footerViewModel else {
            return nil
        }
        let footerView = tableView.dequeueReusableHeaderFooterView(withHeaderFooterModel: footerViewModel)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerViewModel = sectionModels[section].headerViewModel else {
            return 0
        }
        if headerViewModel.height > -1 {
            return headerViewModel.height
        }
        if tableView.sectionHeaderHeight > -1 {
            return tableView.sectionHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerViewModel = sectionModels[section].footerViewModel else {
            return 0
        }
        if footerViewModel.height > -1 {
            return footerViewModel.height
        }
        if tableView.sectionFooterHeight > -1 {
            return tableView.sectionFooterHeight
        }
        return 0
    }
    
}
