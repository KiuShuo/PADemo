//
//  FeedViewController.swift
//  IGListKitLearn
//
//  Created by shuoliu on 2018/12/24.
//  Copyright © 2018 shuo. All rights reserved.
//

import UIKit
import IGListKit

class FeedViewController: UIViewController {
    
    let collectionView: ListCollectionView = {
        let view = ListCollectionView(frame: CGRect.zero, listCollectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false))
        view.backgroundColor = UIColor.black
        return view
    }()
    lazy var adapter: ListAdapter = {
       return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    let wxScanner = WxScanner()
    let loader = JournalEntryLoader()
    let pathfinder = Pathfinder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadLatest()
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        pathfinder.delegate = self
        pathfinder.connect()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}

extension FeedViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items: [ListDiffable] = [wxScanner.currentWeather]
        items += pathfinder.messages as [ListDiffable]
        items += loader.entries as [ListDiffable]
        items.sort { (left, right) -> Bool in
            if let left = left as? DateSortable, let right = right as? DateSortable {
                return left.date > right.date
            }
            return false
        }
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Weather {
            return WeaterSectionController()
        } else if object is Message {
            return MessageSectionController()
        } else {
            return JournalSessionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension FeedViewController: PathfinderDelegate {

    func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
        adapter.performUpdates(animated: true)
    }
    
}
