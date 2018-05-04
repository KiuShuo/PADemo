//
//  FoundationExtensions.swift
//  feng
//
//  Created by luozhijun on 2016/12/30.
//  Copyright © 2016年 shuo. All rights reserved.
//

import UIKit

//MARK: - Dictionary
func + <KeyType, ValueType>(left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
    var result    = [KeyType: ValueType]()
    left.forEach  { result[$0] = $1 }
    right.forEach { result[$0] = $1 }
    return result
}

@discardableResult
func += <KeyType, ValueType>(left: inout [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
    right.forEach { left[$0] = $1 }
    return left
}

//MARK: - Array
@discardableResult
func - <Element: Equatable>(left: inout [Element], right: [Element]) -> [Element] {
    if left.count > right.count {
        for element in right {
            if let removingIndex = left.index(of: element) {
                left.remove(at: removingIndex)
                break
            }
        }
    }
    return left
}

extension Array {
    public mutating func exchange(elementAt sourceIndex: Int, withElementAt targetIndex: Int) {
        if sourceIndex == targetIndex { return }
        let targetElement = self[targetIndex]
        let sourceElement = remove(at: sourceIndex)
        insert(targetElement, at: sourceIndex)
        remove(at: targetIndex)
        insert(sourceElement, at: targetIndex)
    }
    
    public mutating func replace(elementAt index: Int, with element: Element) {
        remove(at: index)
        insert(element, at: index)
    }
}

extension Array where Element: Equatable {
    
    public mutating func replace(_ sourceElement: Element, with targetElement: Element) {
        if let index = index(of: sourceElement) {
            replace(elementAt: index, with: targetElement)
        }
    }
    
    subscript(index: Int, defaultValue defaultValue: Element?) -> Element? {
        if -1 < index && index < count {
            return self[index]
        }
        return defaultValue
    }
    
}

internal func Init<Type>(_ value : Type, block: (_ object: Type) -> Void) -> Type{
    block(value)
    return value
}

