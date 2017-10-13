//
//  PATableViewModelTestModel.swift
//  PADemo
//
//  Created by shuo on 2017/8/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation
import IGListKit

extension NSObject: ListDiffable, PAModelBaseProtocol {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}

class PAListTestModel {
    
    func personList() -> [PAPerson] {
        var persons: [PAPerson] = []
        for i in 0..<100 {
            let person = PAPerson()
            person.name = "num_\(i)"
            person.age = 20 + i
            persons.append(person)
        }
        return persons
    }
    
}

class PAPerson: NSObject {

    var name: String = ""
    var age: Int = 20
}

