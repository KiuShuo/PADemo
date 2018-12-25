//
//  WeaterSectionController.swift
//  IGListKitLearn
//
//  Created by shuo on 2018/12/25.
//  Copyright © 2018 shuo. All rights reserved.
//

import IGListKit

class WeaterSectionController: ListSectionController {
    var weather: Weather!
    var isExpanded = false
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return isExpanded ? 5 : 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        let width = context.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 70)
        } else {
            return CGSize(width: width, height: 40)
        }
    }
    
    override func didUpdate(to object: Any) {
        weather = object as? Weather
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass = index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        if let cell = cell as? WeatherSummaryCell {
            cell.setExpanded(isExpanded)
        } else if let cell = cell as? WeatherDetailCell {
            let title: String, detail: String
            switch index {
            case 1:
                title = "SUNRISE"
                detail = weather.sunrise
            case 2:
                title = "SUNSET"
                detail = weather.sunset
            case 3:
                title = "HIGH"
                detail = "\(weather.high) C"
            case 4:
                title = "LOW"
                detail = "\(weather.low) C"
            default:
                title = "n/a"
                detail = "n/a"
            }
            cell.titleLabel.text = title
            cell.detailLabel.text = detail
        }
        return cell
    }
    
    override func didSelectItem(at index: Int) {
//        isExpanded = !isExpanded
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            self.isExpanded = !self.isExpanded
            batchContext.reload(self)
        })
    }

}
