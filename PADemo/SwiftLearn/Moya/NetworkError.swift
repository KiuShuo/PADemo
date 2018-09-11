//
//  NetworkError.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation

class NetworkError: Error {
    
    var errorCode: String = "0"
    
    var errorMessage: String?
    
    var localizedDescription: String {
        return errorMessage ?? ""
    }
    
    var isRequestCanceled = false
    
    var isIgnoreError = false
    
    init(statusCode: String? = "0") {
        self.errorCode = statusCode ?? "0"
    }
    
    init(statusCode: String? = "0", errorMessage: String?) {
        self.errorCode = statusCode ?? "0"
        self.errorMessage = errorMessage
    }
    
}
