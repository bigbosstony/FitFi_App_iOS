//
//  RecentWorkoutDetailTVCell.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-10.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class RecentWorkoutDetailTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewRWD: UICollectionView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var oneRM: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension RecentWorkoutDetailTVCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionViewRWD.delegate = dataSourceDelegate
        collectionViewRWD.dataSource = dataSourceDelegate
        collectionViewRWD.tag = row
        collectionViewRWD.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionViewRWD.contentOffset.x = newValue }
        get { return collectionViewRWD.contentOffset.x }
    }
}
