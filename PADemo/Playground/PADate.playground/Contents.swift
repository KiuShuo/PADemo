//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

 var dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
 var dateAsString = "2015-10-08 14:25:37"
 var date1 = dateFormatter.date(from: dateAsString)!
 dateAsString = "2018-03-05 08:14:19"
 var date2 = dateFormatter.date(from: dateAsString)!
 
 
 var diffDateComponents = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
 print("The difference between dates is: \(diffDateComponents.year) years, \(diffDateComponents.month) months, \(diffDateComponents.day) days, \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes, \(String(describing: diffDateComponents.second)) seconds")
 




let dateComponentsFormatter = DateComponentsFormatter()
 dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
 let interval = date2.timeIntervalSince(date1)
 print(dateComponentsFormatter.string(from: interval) ?? "")

 
 dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]
 let autoFormattedDifference = dateComponentsFormatter.string(from: date1, to: date2)
 print(autoFormattedDifference ?? "")



 
 func getDateDifferenceValue(dateStr: String) -> String? {
 let currentDate = NSDate()
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
 let date = dateFormatter.date(from: dateStr)
 
 let dateComponentsFormatter = DateComponentsFormatter()
 dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
 dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.hour, NSCalendar.Unit.minute]
 let autoFormattedDifference = dateComponentsFormatter.string(from: currentDate as Date, to: date!)
 return autoFormattedDifference
 }
 
 // 当前时间＋24小时，然后与就诊时间相比较
 // 当前时间与就诊时间相比较，如果早于就诊时间，则进一步比较＋24小时后的时间是否早于就诊时间
 
 
 func dateAfterDayCount(count: Int) -> String {
 let secondsPerDay = TimeInterval(count * 24 * 60 * 60)
 let curDate = NSDate(timeIntervalSinceNow: secondsPerDay)
 
 let dateFormat = DateFormatter()
 dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
 let dateStr = dateFormat.string(from: curDate as Date)
 
 let strTime = "\(dateStr)"
 return strTime
 }
 
 dateAfterDayCount(count: 1)
 
 
 let dateStr = "2016-08-01 15:00:00"
 let dateStrFormatter = dateFormatter.date(from: dateStr)!
 // let difference = getDateDifferenceValue(dateStr)
 
 let date01 = NSDate()
 print(date01.compare(dateStrFormatter))
 
 if date01.compare(dateStrFormatter) == ComparisonResult.orderedDescending {
 print("Date1 is Later than Date2")
 }
 else if date01.compare(dateStrFormatter) == ComparisonResult.orderedAscending {
 print("Date1 is Earlier than Date2")
 }
 else if date01.compare(dateStrFormatter) == ComparisonResult.orderedSame {
 print("Same dates")
 }



func comparaDate(currentDate: NSDate, date: NSDate) -> Int {
    if currentDate.compare(date as Date) == ComparisonResult.orderedDescending {
        return 1
    } else if currentDate.compare(date as Date) == ComparisonResult.orderedAscending {
        return -1
    }
    return 0
}

let dateStr1 = "2016-08-31 16:34"
let dateFormatter1 = DateFormatter()
dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm"
let date = dateFormatter1.date(from: dateStr1)
print(comparaDate(currentDate: NSDate(), date: date! as NSDate))
/*
 if 当前时间 < 就诊时间 {
 if 当前时间+24小时 < 就诊时间 {
 return 24小时之外
 }
 return 24小时之内
 }
 return 24小时之后
 
 */
func dateAfterDayCount(count: Int) -> NSDate {
    let secondsPerDay = TimeInterval(count * 24 * 60 * 60)
    let curDate = NSDate(timeIntervalSinceNow: secondsPerDay)
    return curDate
}
let currentDate = NSDate()
if comparaDate(currentDate: currentDate, date: date! as NSDate) == -1 {
    if comparaDate(currentDate: dateAfterDayCount(count: 1), date: date! as NSDate) == -1 {
        print("24之外")
    } else {
        print("24之内")
    }
} else {
    print("24小时之后")
}

