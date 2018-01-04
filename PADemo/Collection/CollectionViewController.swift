//
//  CollectionViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/12.
//  Copyright © 2017年 shuo. All rights reserved.
//  collectionView代理函数的执行顺序；collectionView中cellForItemAt函数的执行时机。

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    static var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        collectionViewLayout.minimumInteritemSpacing = 0
        return collectionViewLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setupRightBuaButtonItem()
    }
    
    func setupRightBuaButtonItem() {
//        let customButton = UIButton()
//        customButton.setTitle("历史记录", for: .normal)
//        customButton.addTarget(self, action: #selector(pushNewViewController), for: .touchUpInside)
//        customButton.setTitleColor(UIColor.paOrange, for: .normal)
//        customButton.setTitleColor(UIColor.paBlack, for: .highlighted)
//        let rightItem = UIBarButtonItem(customView: customButton)
        let rightItem = UIBarButtonItem(title: "历史记录", style: .done, target: self, action: #selector(pushNewViewController))
        UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(pushNewViewController))
        
        navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    @objc func pushNewViewController() {
        let detail = DetailViewController()
        navigationController?.pushViewController(detail, animated: true)
//        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
    }
    
    // reloadData
    func refresh_1() {
        debugLog("begin reloadData")
        collectionView?.reloadData()
        debugLog("end reloadData")
    }
    
    // reloadItems
    func refresh_2() {
        debugLog("begin reloadData")
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView?.reloadItems(at: [indexPath])
        debugLog("end reloadData")
    }
    
    
    // reloadData + reloadItems
    func refresh_3() {
        refresh_1()
        refresh_2()
    }
    
    // reloadItems + reloadData
    @objc func refresh_4() {
        refresh_2()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.refresh_1()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        debugLog()
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugLog()
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugLog()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.green
    
        return cell
    }

    // MARK: UICollectionViewDelegate

}

// MARK: UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        debugLog()
        return CGSize(width: 100, height: 300)
    }
    
}
