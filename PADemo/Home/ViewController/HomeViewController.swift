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

        //tableView.estimatedRowHeight = 44.0
        //tableView.rowHeight = 44.0
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        
        let _ = UIImage(named: "")
        if let bundlePath = Bundle.main.path(forResource: "ControllerModel", ofType: "plist"),
            let resultDic = NSDictionary(contentsOfFile: bundlePath) as? [String: Any],
            let controllerModelDics = resultDic["result"] as? [[String: String]] {
            self.controllerModels = Mapper<ControllerModel>().mapArray(JSONArray: controllerModelDics)
        }
        convertControllerModelsToSectionModels(controllerModels: controllerModels)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
//        loading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("self.view.subviews = \(self.view.subviews.count)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("self.view.subviews = \(self.view.subviews.count)")
    }
    
    func convertControllerModelsToSectionModels(controllerModels: [ControllerModel]) {
        let cellModels = controllerModels.map { controllerModel -> PACellModel in
            var cellModel = PACellModel(classType: HomeTableViewCell.self)
            cellModel.dataModel = controllerModel
            //cellModel.isEnforceFrameLayout = true
            return cellModel
        }
        tableDelegater.sectionModels = [PASectionModel(cellModelArr: cellModels)]
    }

}

class HomeViewControllerTableDelegater: PATableDelegater {
    
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
/*
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell")
        cell?.accessoryType = .detailButton
        let controllerModel = controllerModels[indexPath.row]
        cell?.textLabel?.text = controllerModel.identifier
        return cell!
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controllerModel = controllerModels[indexPath.row]
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
        
//        baseNavgationController = PABaseNavigationController(rootViewController: toVC)
//        let navgationItem = baseNavgationController?.customLeftBackButton(clickAction: { [weak self] in
//            guard let`self` = self else { return }
//            self.baseNavgationController?.dismiss(animated: true, completion: nil)
//        })
//        customScreenEdgePanGestureRecognizer(navigationController: baseNavgationController!)
//        toVC.navigationItem.setLeftBarButton(navgationItem, animated: true)
//        self.present(baseNavgationController!, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    func customScreenEdgePanGestureRecognizer(navigationController: UINavigationController) {
        var a: UIRectEdge = .right
         let coustomGes = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePan))
        if let ges = getScreenEdgePanGestureRecognizer(view: navigationController.view) {
            a = ges.edges
            ges.require(toFail: coustomGes)
        }
       
        coustomGes.edges = a
        navigationController.view.addGestureRecognizer(coustomGes)
    }
    
    func getScreenEdgePanGestureRecognizer(view: UIView) -> UIScreenEdgePanGestureRecognizer? {
        if let gestureRecognizers = view.gestureRecognizers {
            for ges in gestureRecognizers {
                if ges is UIScreenEdgePanGestureRecognizer {
                    return ges as? UIScreenEdgePanGestureRecognizer
                }
            }
        }
        return nil
    }
    
    func screenEdgePan() {
        baseNavgationController?.dismiss(animated: false, completion: nil)
    }
    
}*/

