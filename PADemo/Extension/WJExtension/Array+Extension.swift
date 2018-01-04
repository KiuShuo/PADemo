//
//  Array+Extension.swift
//  WJExtension
//
//  Created by 靳朋 on 2017/5/25.
//  Copyright © 2017年 wanjia. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    
    public mutating func remove(element: Element) {
        if let removingIndex = index(of: element) {
            remove(at: removingIndex)
        }
    }
    
    public mutating func removes<S>(contentsOf newElements: S) where S : Sequence, S.Iterator.Element == Element {
        newElements.forEach { (element) in
            remove(element: element)
        }
    }
    
}
