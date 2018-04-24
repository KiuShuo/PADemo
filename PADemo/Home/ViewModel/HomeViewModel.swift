//
//  HomeViewModel.swift
//  PADemo
//
//  Created by shuo on 2018/3/14.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeViewModel {
    
    private(set) var controllerModels: [ControllerModel] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeViewModelUpdate"), object: nil)
        }
    }
    
//    var homdeDataDidChange = ObserverSet<Void>()
    
    init(controllerModels: [ControllerModel] = [ControllerModel]()) {
        self.controllerModels = controllerModels
    }
    
    // 获取数据
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let bundlePath = Bundle.main.path(forResource: "ControllerModel", ofType: "plist"),
                let resultDic = NSDictionary(contentsOfFile: bundlePath) as? [String: Any],
                let controllerModelDics = resultDic["result"] as? [[String: String]] {
                self.controllerModels = Mapper<ControllerModel>().mapArray(JSONArray: controllerModelDics)
            }
        }
    }
    
}
