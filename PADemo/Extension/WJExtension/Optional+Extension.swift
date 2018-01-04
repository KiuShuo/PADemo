//
//  Optional+Extensions.swift
//  WJExtension
//
//  Created by 靳朋 on 2017/5/25.
//  Copyright © 2017年 wanjia. All rights reserved.
//
import UIKit

// MARK: - String
public protocol  OptionalSting {}
extension String : OptionalSting {}
public extension Optional where Wrapped: OptionalSting {
    /// 对可选类型的String(String?)安全解包
    public var noneNull: String {
        if let value = self as? String {
            return value
        } else {
            return ""
        }
    }
    
    
    /// 解包可选字符串 并对空字符串设置默认值
    ///
    /// - Parameter defaultStr: 默认值
    public func noneNull(defaultStr: String) -> String {
        if self.noneNull.isEmpty {
            return defaultStr
        } else {
            return self.noneNull
        }
    }
}

// MARK: - Int
public protocol OptionalInt {}
extension Int : OptionalInt {}
public extension Optional where Wrapped: OptionalInt {
    public var noneNull: Int {
        if let value = self as? Int {
            return value
        } else {
            return 0
        }
    }
}

// MARK: - CGFloat
public protocol OptionalCGFloat {}
extension CGFloat : OptionalCGFloat {}
public extension Optional where Wrapped: OptionalCGFloat {
    public var noneNull: CGFloat {
        if let value = self as? CGFloat {
            return value
        } else {
            return 0
        }
    }
}

// MARK: - Double
public protocol OptionalDouble {}
extension Double : OptionalDouble {}
public extension Optional where Wrapped: OptionalDouble {
    public var noneNull: Double {
        if let value = self as? Double {
            return value
        } else {
            return 0
        }
    }
}
