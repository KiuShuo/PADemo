//: Playground - noun: a place where people can play

import UIKit

let key = "abc.123"
debugPrint("key.characters = \(key.characters)")
let delimiter = "."
let arr = key.components(separatedBy: delimiter).filter { !$0.isEmpty }.map { $0.characters }
debugPrint("arr = \(arr)")

let keyComponents = ArraySlice(key.components(separatedBy: delimiter).filter { !$0.isEmpty }.map { $0.characters })

debugPrint("keyComponents = \(keyComponents)")


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
