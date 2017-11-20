//
//  PACalculatorMainMenuModel.swift
//  PADemo
//
//  Created by shuo on 2017/8/31.
//  Copyright © 2017年 shuo. All rights reserved.
//

import ObjectMapper

class PACalculatorMainMenuModel: Mappable, PAModelBaseProtocol {
    var mainMenuName: String = ""
    var detailMenuList: [PACalculatorDetailModel] = []
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        mainMenuName <- map["mainMenuName"]
        detailMenuList <- map["detailMenuList"]
    }
}

class PACalculatorDetailModel: Mappable, PAModelBaseProtocol {
    var name: String = ""
    var id: String = ""
    var calculateCells: [String] = []
    var calculateRules: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        calculateCells <- map["calculateCells"]
        calculateRules <- map["calculateRules"]
    }

}

