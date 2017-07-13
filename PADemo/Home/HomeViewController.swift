//
//  HomeViewController.swift
//  PADemo
//
//  Created by shuo on 2017/4/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var controllerModels: [ControllerModel] = []
    fileprivate var baseNavgationController: PABaseNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = 44.0
        
        if let bundlePath = Bundle.main.path(forResource: "ControllerModel", ofType: "plist"),
            let resultDic = NSDictionary(contentsOfFile: bundlePath) as? [String: Any],
            let controllerModelDics = resultDic["result"] as? [[String: String]] {
            self.controllerModels = Mapper<ControllerModel>().mapArray(JSONArray: controllerModelDics)
        }
    }

}

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
    
}

