//
//  MembersCollectionCell.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/09/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class MembersCollectionCell: UITableViewCell {
    
    @IBOutlet private weak var membersCollectionView: UICollectionView!

}
extension MembersCollectionCell {
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        membersCollectionView.delegate = dataSourceDelegate
        membersCollectionView.dataSource = dataSourceDelegate
        membersCollectionView.tag = row
        membersCollectionView.setContentOffset(membersCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        membersCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            membersCollectionView.contentOffset.x = newValue
        }
        
        get {
            return membersCollectionView.contentOffset.x
        }
    }
}

