//
//  PATableViewDelegate.swift
//  PADemo
//
//  Created by shuo on 2017/5/27.
//  Copyright © 2017年 shuo. All rights reserved.

import Foundation
import UITableView_FDTemplateLayoutCell

class PATableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    /// 外部需传入的数据源
    var sectionModels: [PASectionModel] = []
    
    typealias PATableCellForRowBlock = (tableView: UITableView, indexPath: IndexPath, cell: UITableViewCell, cellModel: PACellModel)
    typealias PATableDelegateConfigBlock = (tableView: UITableView, indexPath: IndexPath, cellModel: PACellModel)
    
    /// 需要单独配置的cell，调用该block
    var configureCell: ((_ tableViewBlockParam: PATableCellForRowBlock) -> Void)?
    /// cell点击事件通过block抛出
    var didSelectCell: ((_ tableViewBlockParam: PATableDelegateConfigBlock) -> Void)?
    /// 高度需要单独处理的cell，调用该block
    var cellHeight: ((_ tableViewBlockParam: PATableDelegateConfigBlock) -> CGFloat)?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModels[section].cellModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = sectionModels[indexPath.section].cellModelArr[indexPath.row]
        let cell = tableView.dequeueReusableCellWithCellModel(cellModel)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = sectionModels[indexPath.section].cellModelArr[indexPath.row]
        if let cellHeight = cellHeight {
            let tableDelegateConfigBlock: PATableDelegateConfigBlock = (tableView, indexPath, cellModel)
            return cellHeight(tableDelegateConfigBlock)
        } else if cellModel.height == -1 {
            if tableView.dequeueReusableCell(withIdentifier: cellModel.identifier) == nil {
                tableView.registCellWithCellModels([cellModel])
            }
            return tableView.fd_heightForCell(withIdentifier: cellModel.identifier, cacheBy: indexPath, configuration: { cell in
                (cell as? UITableViewCell)?.fd_enforceFrameLayout = cellModel.isEnforceFrameLayout
                if var aCell = cell as? PATableViewCellProtocol {
                    aCell.dataModel = cellModel.dataModel
                }
            })
        }
        return cellModel.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let didSelectCell = didSelectCell {
            let cellModel = sectionModels[indexPath.section].cellModelArr[indexPath.row]
            let tableDelegateConfigBlock: PATableDelegateConfigBlock = (tableView, indexPath, cellModel)
            didSelectCell(tableDelegateConfigBlock)
        }
    }
    
}
