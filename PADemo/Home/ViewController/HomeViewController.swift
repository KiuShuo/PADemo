//
//  HomeViewController.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

/*
 [NSDecimalNumber 四舍五入到指定位数](http://www.colinhwang.com/2016/06/22/round-number/)
 [Swift-NumberFormatter的简单使用](http://blog.csdn.net/longshihua/article/details/54630616)
 */

import UIKit
import ObjectMapper
import MBProgressHUD

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var controllerModels: [ControllerModel] = []
    fileprivate lazy var tableDelegater: HomeViewControllerTableDelegater = {
        let delegater = HomeViewControllerTableDelegater()
        delegater.viewController = self
        return delegater
    }()
    fileprivate var baseNavgationController: PABaseNavigationController?
    var viewModel: HomeViewModel = HomeViewModel() {
        didSet {
            updateUI()
        }
    }
    
    
    func testMBProgressHUD(isShow: Bool) {
        if isShow {
            MBProgressHUD.hide(for: self.view, animated: false)
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func loading() {
        // delay <= 0.3时 且 从详情界面快速返回
        /**
         // 同时满足下面三个条件，会出现loading圈不消失：
         1. 在viewWillAppear中调用；
         2. delay <= 0.3;
         3. 从详情界面快速滑动返回（注意一定要滑动 一定要快）。
         */
        let delay: TimeInterval = 0.1
        testMBProgressHUD(isShow: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.testMBProgressHUD(isShow: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        let footerView = UIView()
        footerView.frame.size.height = 50
        self.tableView.tableFooterView = footerView
        self.tableView.tableFooterView?.backgroundColor = UIColor.green
        tableView.separatorStyle = .none
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "homeViewModelUpdate"), object: nil, queue: nil) { (notification) in
            self.viewModel = HomeViewModel(controllerModels: self.viewModel.controllerModels)
        }
        viewModel.fetchData()
    }
    
    func updateUI() {
//        setupSectionModel()
        convertControllerModelsToSectionModels(controllerModels: viewModel.controllerModels)
        tableView.reloadData()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.width - 28, height: 80)
        let footerView = PAMovingDossierTableFooterView.instanceFromXib(frame: frame)
        tableView.tableFooterView = footerView
    }
    
    func convertControllerModelsToSectionModels(controllerModels: [ControllerModel]) {
        let cellModels = controllerModels.map { controllerModel -> PACellModel in
            var cellModel = PACellModel(classType: HomeViewCell.self)
            cellModel.dataModel = controllerModel
            cellModel.isNeedRegister = false
            return cellModel
        }
//        let sectionModels = cellModels.map { (cellModel) -> PASectionModel in
//            return PASectionModel(cellModelArr: [cellModel])
//        }
        tableDelegater.sectionModels = [PASectionModel(cellModelArr: cellModels)]
    }
    
    func setupSectionModel() {
        let model1 = DetailModel()
        model1.aNumber = "#123 #23 #23 #34 #56"
        let model2 = DetailModel()
        model2.aNumber = "#23 #23 #23 #34 #56 #123 #23 #23 #34 #56"
        let model3 = DetailModel()
        model3.aNumber = "#31 #23 #23 #34 #56 #123 #23 #23 #34 #56"
        let model4 = DetailModel()
        model4.aNumber = "#40 #23 #23 #34 #56"
        let models: [DetailModel] = [model1, model2, model3, model4]
        let cellModel = PACellModel(classType: PAMovingDossierListCell.self, dataModel: models)
        tableDelegater.sectionModels = [PASectionModel(cellModelArr: [cellModel])]
    }

}



class HomeViewControllerTableDelegater: PATableDelegater {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = self.cellModel(indexPath)
        guard let controllerModel = cellModel.dataModel as? ControllerModel else {
            return
        }

        var toViewController: UIViewController?
        
        switch controllerModel.identifier {
        case String(describing: CollectionViewController.self):
            toViewController = CollectionViewController(collectionViewLayout: CollectionViewController.collectionViewLayout)
        default:
            if let controller = ControllerUtil.makeController(controllerModel: controllerModel) {
                toViewController = controller
            }
        }
        guard let toVC = toViewController else {
            return
        }
        /*
        let navigation = PABaseNavigationController(rootViewController: toVC)
        viewController?.present(navigation, animated: true, completion: nil)
         */
        viewController?.navigationController?.pushViewController(toVC, animated: true)
    }
     

}
