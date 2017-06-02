//
//  NSDate+Extension.swift
//  wanjia2B
//
//  Created by luozhijun on 2016/11/22.
//  Copyright © 2016年 pingan. All rights reserved.
//

import Foundation

public extension Date {
    
    /// 创建一个只含有`年月`的日期字符串, 默认格式是"YYYY-MM"
    public func toMonthString(by formate: String = "YYYY-MM") -> String {
        return toString(by: "YYYY-MM")
    }
    
    /// 通过给定的日期格式创建一个日期字符串, 默认的formate是"YYYY-MM-dd"
    public func toString(by formate: String = "YYYY-MM-dd") -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: self)
    }
    
    /// 比较两个日期是否相同
    public func isSame(to date: Date, by formate: String = "YYYY-MM-dd") -> Bool {
        return self.toString(by: formate) == date.toString(by: formate)
    }
    
    /// 修改一个日期的组件, 比如给月份加1减1之类, 负数表示往前推移
    public mutating func alter(components: Calendar.Component, amount: Int) -> Date {
        var dateComponents = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        dateComponents.timeZone = TimeZone.current
        switch components {
        case .day:
            dateComponents.day         = amount
        case .month:
            dateComponents.month       = amount
        case .weekOfYear:
            dateComponents.weekOfYear  = amount
        case .weekOfMonth:
            dateComponents.weekOfMonth = amount
        case .weekday:
            dateComponents.weekday     = amount
        default:
            return self
        }
        if let date = calendar.date(byAdding: dateComponents, to: self) {
            self = date
        }
        return self
    }
    
    /// 返回一个日期的组件，可多选
    public func components(_ components: Calendar.Component) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(components, from: self)
    }
    
    /// 返回与另一个日期之间的比较
    public func dateComponents(_ components: Set<Calendar.Component>, between date: Date) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents(components, from: self, to: date)
    }
}
