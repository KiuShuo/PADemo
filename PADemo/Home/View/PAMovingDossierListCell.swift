//
//  PAMovingDossierListCell.swift
//  wanjia2B
//
//  Created by shuo on 2018/7/10.
//  Copyright © 2018年 pingan. All rights reserved.
//

import UIKit

class PAMovingDossierListCell: UITableViewCell, PATableViewCellProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var dataModel: PAModelBaseProtocol? {
        didSet {
            if let models = dataModel as? [DetailModel] {
                reloadTreatmentTableView(models)
            }
        }
    }
    
    var delegater = PATableDelegater()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        contentView.layoutIfNeeded()
        tableView.separatorStyle = .none
        tableView.delegate = delegater
        tableView.dataSource = delegater
    }
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        tableView.frame.size.width = size.width
//        tableView.layoutIfNeeded()
//        let height = tableView.contentSize.height + 3
//        print("height = \(height) \(tableView)")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let height1 = self.tableView.contentSize.height + 3
//            print("height1 = \(height1) \(self.tableView)")
//        }
//        return CGSize(width: size.width, height: height)
//    }
    
    
    private func reloadTreatmentTableView(_ models: [DetailModel]) {
        let sectionModel = PASectionModel(cellClassType: PAMouthTherapyCell.self, dataModels: models)
        delegater.sectionModels = [sectionModel]
        tableView.reloadData()
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    deinit {
        print(self, "执行")
    }
    
}

