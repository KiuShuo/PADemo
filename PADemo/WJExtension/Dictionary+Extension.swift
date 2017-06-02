//
//  Dictionary+Extension.swift
//  WJExtension
//
//  Created by 靳朋 on 2017/5/25.
//  Copyright © 2017年 wanjia. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    public mutating func update(contentsOf other: Dictionary) {
        other.forEach { self[$0] = $1 }
    }
    
    public var jsonString: String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}
