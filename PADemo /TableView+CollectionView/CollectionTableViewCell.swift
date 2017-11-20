//
//  CollectionTableViewCell.swift
//  PADemo
//
//  Created by shuo on 2017/7/24.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        bottomView.layer.shadowColor = UIColor.gray.cgColor
        bottomView.layer.shadowOpacity = 0.4
        bottomView.layer.shadowOffset = CGSize(width: -3, height: 3)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 100)
    }
    
}

extension CollectionTableViewCell: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
    
}
