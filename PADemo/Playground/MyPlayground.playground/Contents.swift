//: Playground - noun: a place where people can play
// 函数式编程

import UIKit

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    
    func whithin(range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
    
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var length: Double {
//        print(x)
//        print(y)
        return sqrt(x * x + y * y)
    }
    
    // 圆点坐标在(0, 0)的圆
//    static func circle(radius: Distance) -> Region {
//        return { point in point.length < radius }
//    }
//
//    static func shift(_ region: @escaping Region, by offset: Position) -> Region {
//        return { point in region(point.minus(offset)) }
//    }
    
    
}

//let position = Position(x: 10, y: 10)
//let region1 = Position.circle(radius: 10)
//region1(Position(x: 7, y: 7))

//let shifted = Position.shift(Position.circle(radius: 10), by: Position(x: 1, y: 1))
//shifted(Position(x: 9, y: 8))

typealias Region = (Position) -> Bool

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    // 圆点坐标在(0, 0)的圆
    func circle(radius: Distance) -> Region {
        return { point in point.length < radius }
    }
    //
    func shift(_ region: @escaping Region, by offset: Position) -> Region {
        return { point in region(point.minus(offset)) }
    }
    
    // 区域反转
    func invert(_ region: @escaping Region) -> Region {
        return { point in !region(point) }
    }
    // 区域相交/交集
    func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
        return { point in region(point) && other(point) }
    }
    // 区域并集
    func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
        return { point in region(point) || other(point) }
    }
    // 区域差集
    func subtract(_ region: @escaping Region, from origin: @escaping Region) -> Region {
        return intersect(_: origin, with: invert(region))
    }
    
}

extension Ship {
    
    func canEngage(ship target: Ship) -> Bool {
        let dPosition = position.minus(target.position)
        let targetDistance = dPosition.length
//        let dx = target.position.x - position.x
//        let dy = target.position.y - position.y
//        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
    
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
//        let dx = target.position.x - position.x
//        let dy = target.position.y - position.y
//        let targetDistance = sqrt(dx * dx + dy * dy)
        let targetDistance = position.minus(target.position).length
        
//        let friendlyDx = friendly.position.x - target.position.x
//        let friendlyDy = friendly.position.y - target.position.y
//        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        let friendlyDistance = friendly.position.minus(target.position).length
        
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && friendlyDistance > unsafeRange
    }
    
    func canSafelyEngage1(ship target: Ship, friendly: Ship) -> Bool {
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        let firingRegion = shift(rangeRegion, by: position)
        let friendlyRegion = shift(circle(radius: unsafeRange), by: friendly.position)
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        return resultRegion(target.position)
    }
    
}

