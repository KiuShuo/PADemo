//: Playground - noun: a place where people can play

import UIKit

var str1: Any? = "1"
var oneValue: Int = 0
let str = oneValue as? String
str


//func test(letf: inout Any, righ: Any?) {
//    if let righ = righ {
//        letf = righ
//    }
//}
//
//test(letf: &oneValue, righ: str1)
//oneValue

/*
func remoteNotification() {
    /// 远程通知判断是否允许alert badge sound 可以通过type.rawValue是否为0来判断是都允许了远程通知 当然这也是一种计较模糊的判断，因为
    let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
    let notificationTypes0: UIUserNotificationType = [.alert, .badge]
    let notificationTypes1: UIUserNotificationType = [.alert, .sound]
    let notificationTypes2: UIUserNotificationType = [.badge, .sound]
    let notificationTypes3: UIUserNotificationType = [.badge]
    let notificationTypes4: UIUserNotificationType = [.sound]
    let notificationTypes5: UIUserNotificationType = [.alert]
    
    notificationTypes0.rawValue
    notificationTypes1.rawValue
    notificationTypes2.rawValue
    notificationTypes3.rawValue
    notificationTypes4.rawValue
    notificationTypes5.rawValue
    
    print("notificationTypes.rawValue = \(notificationTypes.rawValue)")
    if let types = UIApplication.shared.currentUserNotificationSettings?.types {
        if types.rawValue != 0 {
            print("允许推送")
        } else {
            print("未允许推送")
        }
    } else {
        print("未允许推送")
    }
}

remoteNotification()
*/


/*
let key = "abc.123"
debugPrint("key.characters = \(key.characters)")
let delimiter = "."
let arr = key.components(separatedBy: delimiter).filter { !$0.isEmpty }.map { $0.characters }
debugPrint("arr = \(arr)")

let keyComponents = ArraySlice(key.components(separatedBy: delimiter).filter { !$0.isEmpty }.map { $0.characters })
debugPrint("keyComponents = \(keyComponents)")
*/

//let name = "Marie Curie"
//if let firstSpace = name.characters.index(of: " ") {
//    print("firstSpace = \(firstSpace)")
//    let firstName = String(name.characters.prefix(upTo: firstSpace))
//    print(firstName)
//}

//class Single {
//    static var single: Single = Single()
//    var str: String = "123"
//}
//
//let singleOne = Single.single
//singleOne.str = "234"
//
//let singleTwo = Single()
//singleOne.str
//Single.single = singleTwo
//singleOne.str
//singleTwo.str

//let



/*
 var aStr: String = "123"
 aStr = "234" + "345"
 
 var aStaticStr: StaticString = "abc"
 aStaticStr = "bcd"// + "cde"
 
 struct Point: CustomStringConvertible {
 let x: Int, y: Int
 var description: String {
 return "(\(x), \(y))"
 }
 }
 let p = Point(x: 21, y: 30)
 let s = String(describing: p)
 print(s)
 // Prints "(21, 30)"
 
 let arr = [1, 2, 3, 4]
 for a in arr.reversed() {
 debugPrint(a)
 if a == 3 {
 break
 }
 }
 
 
 arr
 
 enum Type: Int {
 case one = 1
 case two
 }
 
 let type: Type = .two
 Type.two.rawValue
 */


/*
 func + <KeyType, ValueType>(left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
 var result    = [KeyType: ValueType]()
 left.forEach  { result[$0] = $1 }
 right.forEach { result[$0] = $1 }
 return result
 }
 
 var result: [String: String] = [:]
 let dic = ["1": "A", "2": "B"]
 dic.forEach {
 debugPrint($0)
 debugPrint($1)
 result[$0] = $1
 }
 dic.first!.key
 dic.first!.value
 result
 let dic1 = ["1": "C"]
 dic + dic1
 
 
 
 class Person: NSObject {
 var name: String?
 }
 
 let per = Person()
 per.name
 
 let a = "ABC"
 if a == "abc" {
 debugPrint("hehe")
 }
 */

/*
 var array = [1,2,3]
 for (i, index) in array.enumerated() {
 //    array.removeLast()
 print(index)
 if index == 2 {
 array.remove(at: i)
 }
 }
 array
 
 var thing = "cars"
 let closure = {
 print("I love \(thing)")
 }
 thing = "airplanes"
 closure()
 
 struct Point {
 var x = 0.0, y = 0.0
 }
 struct Size {
 var width = 0.0, height = 0.0
 }
 struct Rect {
 var origin = Point()
 var size = Size()
 var center: Point {
 get {
 let centerX = origin.x + (size.width / 2)
 let centerY = origin.y + (size.height / 2)
 return Point(x: centerX, y: centerY)
 }
 set(newCenter) {
 origin.x = newCenter.x - (size.width / 2)
 origin.y = newCenter.y - (size.height / 2)
 }
 }
 }
 
 var square = Rect(origin: Point(x: 0.0, y: 0.0),
 size: Size(width: 10.0, height: 10.0))
 let initialSquareCenter = square.center
 square.center = Point(x: 15.0, y: 15.0)
 print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
 
 
 struct Person {
 var name: String?
 var age: Int?
 
 //    init(name: String) {
 //        self.name = name
 //    }
 }
 
 var pppp = Person(name: "", age: 0)
 pppp.name = "1233"
 
 //var per: Person? = nil {
 //    didSet {
 //        print("gagag\(per?.name)")
 //
 //        withUnsafePointer(to: &per) {
 //            print("address: \($0)")
 //        }
 //    }
 //}
 //
 ////per = Person(name: "aaa")
 //var ppp = Person.init(name: "ddd")
 //per = ppp
 //per?.name = "dddd"
 
 */

let arr: [String] = ["1", "2", "3"]
arr.joined()
arr.joined(separator: "-")
