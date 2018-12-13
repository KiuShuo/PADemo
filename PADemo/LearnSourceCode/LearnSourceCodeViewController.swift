//
//  LearnSourceCodeViewController.swift
//  PADemo
//
//  Created by shuo on 2018/11/27.
//  Copyright © 2018 shuo. All rights reserved.
//

import UIKit

class LearnSourceCodeViewController: PAListViewController {

    private var names = ["AFNetworking-URLSession", "AFNetworking-AFURLSessionManager"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellModels: [PACellModel] = names.map { name in
            var cellMdeol = PACellModel(classType: UITableViewCell.self, dataModel: SourceCodeModel(name: name), height: 40)
            cellMdeol.cellName = name
            return cellMdeol
        }
        let sectionModel = PASectionModel(cellModelArr: cellModels)
        reloadData([sectionModel])
        setupTableDelegater()
    }
    
    private func setupTableDelegater() {
        tableDelegater.configureCell = { paramModel in
            if let model = paramModel.cellModel.dataModel as? SourceCodeModel {
                paramModel.cell.textLabel?.text = model.name
            }
        }
        
        tableDelegater.didSelectCell = { [weak self] paramModel in
            guard let name = paramModel.cellModel.cellName,
                  let `self` = self else {
                    return
            }
            switch name {
            case "AFNetworking-URLSession":
                let vc = LearnAFViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case "AFNetworking-AFURLSessionManager":
                let vc = LearnViewController_AFURLSessionManager()
                self.navigationController?.pushViewController(vc, animated: true)
            default:()
            }
        }
    }
    
}

struct SourceCodeModel: PAModelBaseProtocol {
    var name: String = ""
}
