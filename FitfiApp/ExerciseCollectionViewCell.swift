//
//  ExerciseCollectionViewCell.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-14.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell {
    
    var numberOfSets: Int?
    
    @IBOutlet weak var setCollectionViewCell: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionViewCell.delegate = self
        setCollectionViewCell.dataSource = self
    }
}

extension ExerciseCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSets ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "setCVCell", for: indexPath)
        
        return cell
    }
    
    
}
