//
//  Response.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import Moya

// 分页
struct PageModel {
    
}

class Response {
    
    var urlResponse: URLResponse?
    
    var responseData: Data?
    
    init(response: Moya.Response) {
        self.urlResponse = response.response
        self.responseData = response.data
    }
    
    lazy var json: [String: Any]? = {
        guard let response = self.responseData else {
            return nil
        }
        var responseDic: [String: Any] = [:]
        if let dict = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers), dict is [String: Any] {
            if let dic = dict as? [String: Any] {
                responseDic = dic
            }
        }
        return responseDic
    }()
}

class ListResponse<T>: Response where T: Codable {
//    var dataList: [T]? {
//        guard code == 0,
//            let jsonData = jsonData as? [String : Any],
//            let listData = jsonData["list"],
//            let temp = json2Data(listData) else {
//                return nil
//        }
//        return try? JSONDecoder().decode([T].self, from: temp)
//    }
    
    var page: PageModel? {
        // PageModel的解析
        return nil
    }
}

class ModelResponse<T>: Response where T: Codable {
//    var data: T? {
//        guard code == 0,
//            let tempJSONData = jsonData,
//            let temp = json2Data(tempJSONData)  else {
//                return nil
//        }
//        return try? JSONDecoder().decode(T.self, from: temp)
//    }
}
