//
//  PacCollectionCell.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 21/02/17.
//  Copyright © 2017 appstudioz. All rights reserved.
//

import UIKit

class PacCollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    //MARK:- Properties
    

    //MARK:- initialization methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK:- Setup collectionView datasource and delegate
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
        
        //collectionView.delegate = dataSourceDelegate
        //collectionView.dataSource = dataSourceDelegate
        //collectionView.tag = row
        //collectionView.reloadData()
    }

}
