//
//  Model.swift
//  PADemo
//
//  Created by shuo on 2017/4/28.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation
import ObjectMapper

class ControllerModel: NSObject, Mappable {

    var id: String?
    var identifier: String = ""
    var descriotion: String = ""
    var isStoryboard: Bool = false // 1:true 0:false
    private var isStoryboardStr: String? {
        didSet {
            if isStoryboardStr == "1" {
                isStoryboard = true
            }
        }
    }
    var storyboardName: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        identifier <- map["identifier"]
        descriotion <- map["descriotion"]
        isStoryboardStr <- map["isStoryboard"]
        storyboardName <- map["storyboardName"]
    }
    
}

class ControllerUtil {
    
    static func viewControllerClass(with name: String) -> UIViewController.Type? {
        if let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
            if let viewControllerClass = NSClassFromString(nameSpace + "." + name) as? UIViewController.Type {
                return viewControllerClass
            }
        }
        return nil
    }
    
    class func instantiateControllerWithIdentifier(_ identifier: String, StoryboardName name: String = "Main", bundle: Bundle?) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    static func makeController(controllerModel: ControllerModel) -> UIViewController? {
        if controllerModel.isStoryboard {
            if let storyboardName = controllerModel.storyboardName,
                !controllerModel.identifier.isEmpty {
                return instantiateControllerWithIdentifier(controllerModel.identifier, StoryboardName: storyboardName, bundle: nil)
            }
        }
        
        if !controllerModel.identifier.isEmpty,
           let controllerClass = ControllerUtil.viewControllerClass(with: controllerModel.identifier) {
            return controllerClass.init()
        }
        return nil
    }
    
}
