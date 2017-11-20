//
//  PAPersonSectionController.swift
//  PADemo
//
//  Created by shuo on 2017/8/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import Foundation
import IGListKit

class PAPersonSectionController: ListSectionController {
    
    var person: PAPerson!
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: UIScreen.width, height: 80)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: String(describing: PAPersonCollectionViewCell.self), bundle: nil, for: self, at: index) as! PAPersonCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.nameLabel.text = person.name
        cell.ageLabel.text = "\(person.age + 20)"
        return cell
    }
    
    override func didUpdate(to object: Any) {
        person = object as! PAPerson
    }
    
    override func didSelectItem(at index: Int) {
        // listSectionController对collectionContext是弱引用，因此内部使用self无需weak
        collectionContext?.performBatch(animated: true, updates: { (listBatchContext) in
            print("currentSelectedIndex = \(index)")
        }, completion: nil)
    }
    
}
