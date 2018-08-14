//
//  collectionView-In-CVC-Testing.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-13.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class collectionView_In_CVC_Testing: UIViewController {

    @IBOutlet weak var exerciseCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseCollectionView.delegate = self
        exerciseCollectionView.dataSource = self
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension collectionView_In_CVC_Testing: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testingRoutine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCVCell", for: indexPath) as! ExerciseCollectionViewCell
        cell.numberOfSets = testingRoutine[indexPath.row]["sets"] as? Int
        
        return cell
    }
    
    
}
