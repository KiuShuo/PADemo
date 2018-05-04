//
//  NSDate+Extension.swift
//  feng
//
//  Created by luozhijun on 2016/11/22.
//  Copyright © 2016年 shuo. All rights reserved.
//

import Foundation

private var dateFormatterCache = [String: DateFormatter]()

public extension DateFormatter{
    
    /// 创建DateFormatter和修改DateFormatter.dateFormat同样耗费性能
    /// 参考文章：https://stackoverflow.com/questions/27321993/is-caching-a-nsdateformatter-application-wide-good-idea
    /// 获取 DateFormatter， 该方法会缓存DateFormatter，优化性能
    ///
    /// - Parameter key: formate
    public static func cache(formate key: String) -> DateFormatter {
        var formatter = dateFormatterCache[key]
        if formatter == nil {
            let tempFormatter = DateFormatter()
            tempFormatter.locale = Locale(identifier: "zh_CN")
            tempFormatter.dateFormat = key
            dateFormatterCache[key] = tempFormatter
            formatter = tempFormatter
        }
        return formatter!
    }
}

public extension Date {
    
    /// 当前月份第一天
    public static var currentMonthFirstDayOfDate: Date{
        return Date().monthFirstDayOfDate
    }
    
    /// 月份的第一天
    public var monthFirstDayOfDate: Date{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: self)
        return calendar.date(from: components)!
    }
    
    /// 月份的最后一天
    public var monthLastDayOfDate: Date{
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year,.month,.day], from: self)
        components.month = components.month! + 1
        components.day = 0
        return calendar.date(from: components)!
    }
    
    /// 凌晨时间
    public var amZeroDate: Date{
        //Calendar.current.startOfDay(for: self)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    /// 周的第几天时间
    ///
    /// - Parameters:
    ///   - num: 第一天为周日， 即1->周日，2->周一，3->周二 ... 7->周六
    ///   - weekNum: 下几周或者前几周，如1代表下一周，-1代表上一周
    /// - Returns: Date
    public func weekDay(num:Int, appendWeek weekNum:Int = 0) ->Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year,.month,.weekOfYear,.weekday], from: self)
        components.weekday = num
        components.weekOfYear = components.weekOfYear! + weekNum
        return calendar.date(from: components)!
    }
    
    /// 创建一个只含有`年月`的日期字符串, 默认格式是"yyyy-MM"
    public func toMonthString() -> String {
        return toString(by: "yyyy-MM")
    }
    
    /// 通过给定的日期格式创建一个日期字符串, 默认的formate是"yyyy-MM-dd"
    public func toString(by formate: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter.cache(formate: formate)
        return dateFormatter.string(from: self)
    }
    
    /// 比较两个日期是否相同
    public func isSame(to date: Date, by formate: String = "yyyy-MM-dd") -> Bool {
        return self.toString(by: formate) == date.toString(by: formate)
    }
    
    /// 修改一个日期的组件, 比如给月份加1减1之类, 负数表示往前推移
    @discardableResult
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
        case .year:
            dateComponents.year        = amount
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
