//
//  PACalculatorMenuViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/31.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import ObjectMapper

class PACalculatorMenuViewController: BaseViewController {
    
    fileprivate var mainMenuTableView = UITableView()
    fileprivate var detailMenuTableDelegater = PACalculatorMainMenuTableDelagater()
    fileprivate var detailMenuTableView = UITableView()
    fileprivate var detailTableDelegater = PACalculatorDetailTableDelegater()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "医学计算器"
        setupData()
        setupTableView()
    }
    
    private func setupData() {
        var mainMenuModels: [PACalculatorMainMenuModel] = []
        if let bundlePath = Bundle.main.path(forResource: "PACalculatorModel", ofType: "plist"),
            let resultDic = NSDictionary(contentsOfFile: bundlePath) as? [String: Any],
            let jsonModels = resultDic["result"] as? [[String: Any]] {
            let models = Mapper<PACalculatorMainMenuModel>().mapArray(JSONArray: jsonModels)
            let mainMenuModel = PACalculatorMainMenuModel()
            mainMenuModel.mainMenuName = "全部"
            models.forEach { model in
                mainMenuModel.detailMenuList += model.detailMenuList
            }
            mainMenuModels.append(mainMenuModel)
            mainMenuModels += models
        }
        
        let indexCellModel = PACellModel(identifier: String(describing: PACalculatorMainMenuCell.self), height: 100)
        detailMenuTableDelegater.sectionModels = [PASectionModel(cellModel: indexCellModel, dataModels: mainMenuModels)]
        
        detailTableDelegater.sectionModels = [PASectionModel(cellModel: PACalculatorDetailMenuCell.cellModel, dataModels: mainMenuModels.first!.detailMenuList)]
    }
    
    private func setupTableView() {
        view.addSubview(mainMenuTableView)
        mainMenuTableView.mas_makeConstraints { make in
            make!.top.equalTo()(UIScreen.navigationHeight)
            make!.left.bottom().equalTo()
            make!.width.equalTo()(100)
        }
        
        mainMenuTableView.separatorStyle = .none
        mainMenuTableView.backgroundColor = UIColor(withRGBValue: 0xd9d9d9)
        mainMenuTableView.delegate = detailMenuTableDelegater
        mainMenuTableView.dataSource = detailMenuTableDelegater
        detailMenuTableDelegater.viewController = self
        detailMenuTableDelegater.tableView = mainMenuTableView
        
        view.addSubview(detailMenuTableView)
        detailMenuTableView.mas_makeConstraints { make in
            make!.left.equalTo()(self.mainMenuTableView.mas_right)
            make!.right.bottom().equalTo()
            make!.top.equalTo()(UIScreen.navigationHeight)
        }
        detailMenuTableView.separatorStyle = .none
        detailMenuTableView.backgroundColor = UIColor.white
        detailMenuTableView.delegate = detailTableDelegater
        detailMenuTableView.dataSource = detailTableDelegater
        detailTableDelegater.viewController = self
    }
    
}

class PACalculatorMainMenuTableDelagater: PATableDelegater {
    
    private var currentSelectedIndexPath = IndexPath(row: 0, section: 0)
    
    private func tapDepartButton(sender: UIButton, indexPath: IndexPath) {
        if currentSelectedIndexPath == indexPath {
            return
        }
        sender.isSelected = true
        let cellModel = self.cellModel(indexPath)
        guard let mainMenuModel = cellModel.dataModel as? PACalculatorMainMenuModel else { return }
        guard let calculatorMenuController = viewController as? PACalculatorMenuViewController else { return }
        calculatorMenuController.detailTableDelegater.sectionModels = [PASectionModel(cellModel: PACalculatorDetailMenuCell.cellModel, dataModels: mainMenuModel.detailMenuList)]
        calculatorMenuController.detailMenuTableView.reloadData()

        if let lastSelectedCell = tableView?.cellForRow(at: currentSelectedIndexPath) as? PACalculatorMainMenuCell {
            lastSelectedCell.departButton.isSelected = false
        }
        
        currentSelectedIndexPath = indexPath
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cellModel = self.cellModel(indexPath)
        switch cellModel.identifier {
        case String(describing: PACalculatorMainMenuCell.self):
            let buttonCell = cell as! PACalculatorMainMenuCell
            buttonCell.tapButton = { [weak self] button in
                self?.tapDepartButton(sender: button, indexPath: indexPath)
            }
            buttonCell.departButton.isSelected = indexPath == currentSelectedIndexPath
        default: ()
        }
        return cell
    }
    
}

class PACalculatorDetailTableDelegater: PATableDelegater {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = self.cellModel(indexPath)
        if let model = cellModel.dataModel as? PACalculatorDetailModel {
            let calculateViewController = PACalculateViewController(calculatorDetailModel: model)
            self.viewController?.navigationController?.pushViewController(calculateViewController, animated: true)
        }
    }
    
}
