//: Playground - noun: a place where people can play

import UIKit

func test(a: Int?) -> Int? {
    if let a = a {
        return a + 1
    }
    return nil
}

let arr = [1, 2, nil, 3]

let arr1: [Int?] = arr.map { (a) -> Int? in
    test(a: a)
}
arr1

let arr2: [Int] = arr.compactMap { (a) -> Int? in
    test(a: a)
}



