//
//  PAPersonListViewController.swift
//  PADemo
//
//  Created by shuo on 2017/8/7.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import IGListKit

class PAPersonListViewController: BaseViewController {
    
    let listTestModel = PAListTestModel()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
//        view.addSubview(collectionView)
//        collectionView.mas_makeConstraints { make in
//            make!.edges.equalTo()
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let redVC = BaseViewController()
        redVC.view.backgroundColor = UIColor.red
        let viewControlls = [navigationController!.viewControllers.first!, redVC]
        navigationController?.setViewControllers(viewControlls, animated: true)
    }

}

extension PAPersonListViewController: ListAdapterDataSource {
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let emptyView = UIView()
        emptyView.backgroundColor = UIColor.yellow
        return emptyView
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return listTestModel.personList()
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PAPersonSectionController()
    }
    
}
