//
//  PACalculateViewController.swift
//  PADemo
//
//  Created by shuo on 2017/9/12.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PACalculateViewController: BaseTableViewController {
    
    private var tableDelegater = PACalculateTableDelegater()
    fileprivate var calculatorDetailModel: PACalculatorDetailModel!
    
    convenience init(calculatorDetailModel: PACalculatorDetailModel) {
        self.init()
        self.calculatorDetailModel = calculatorDetailModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = calculatorDetailModel.name
        setupTableView()
        configureDelegater()
    }
    
    private func setupTableView() {
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.separatorStyle = .none
        tableDelegater.viewController = self
    }
    
    private func configureDelegater() {
        var cellModels: [PACellModel] = []
        calculatorDetailModel.calculateCells.forEach { calculateCell in
            if let calculateCellClass = PATableViewModel.tableViewCellClass(with: calculateCell) {
                let calculateCellModel = PACellModel(classType: calculateCellClass)
                cellModels.append(calculateCellModel)
            }
        }
        if !calculatorDetailModel.calculateRules.isEmpty {
            var rulesCellModel = PACellModel(classType: PACalculateRulesCell.self)
            rulesCellModel.dataModel = calculatorDetailModel
            cellModels.append(rulesCellModel)
        }
        tableDelegater.sectionModels.append(PASectionModel(cellModelArr: cellModels))
        tableView.reloadData()
    }

}

class PACalculateTableDelegater: PATableDelegater {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        /*
        guard let calculateVC = self.viewController as? PACalculateViewController else {
            return cell
        }
        let calculatorDetailModel = calculateVC.calculatorDetailModel
        let cellModel = self.cellModel(indexPath)
        switch cellModel.identifier {
        case String(describing: <#PACalculate#>.self):
            //
        default: ()
        }
         */
        return cell
    }
    
}
