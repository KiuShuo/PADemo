//
//  PATableViewDelegate.swift
//  PADemo
//
//  Created by shuo on 2017/5/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation
import Masonry

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
        } else {
            if var aCell = cell as? PATableViewCellProtocol {
                aCell.dataModel = cellModel.dataModel
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = sectionModels[indexPath.section].cellModelArr[indexPath.row]
        if let cellHeight = cellHeight {
            return cellHeight(tableView, indexPath, cellModel)
        }
        if cellModel.height == -1 {
            return UITableViewAutomaticDimension
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
