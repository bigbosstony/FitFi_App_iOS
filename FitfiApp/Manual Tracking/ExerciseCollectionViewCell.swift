//
//  ExerciseCollectionViewCell.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-14.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import AVFoundation

protocol ExerciseCollectionViewCellDelegate: class {
    func ExerciseCollectionViewCellDidTapPlus(_ sender: ExerciseCollectionViewCell)
    func ExerciseCollectionViewCellDidTapMinus(_ sender: ExerciseCollectionViewCell)
}

class ExerciseCollectionViewCell: UICollectionViewCell {
    
    var setArray: [Int16] = []
    var setDoneArray: [Bool] = []
    var weightArray: [Int16] = []
    var indexPath: IndexPath!
    
    @IBOutlet weak var setCollectionView: UICollectionView!
    @IBOutlet weak var weightLabel: UITextField!
    @IBOutlet weak var mainCounterLabel: UILabel!
    
    weak var delegate: ExerciseCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView.delegate = self
        setCollectionView.dataSource = self
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
//        if let index = setDoneArray.index(of: false) {
//            let numberIncreaseOne = setArray[index] + 1
//            setArray[index] = numberIncreaseOne
//            mainCounterLabel.text = String(numberIncreaseOne)
//            setCollectionView.reloadData()
//        }
        AudioServicesPlaySystemSound(1104)
        delegate?.ExerciseCollectionViewCellDidTapPlus(self)
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1104)
        delegate?.ExerciseCollectionViewCellDidTapMinus(self)
    }
}

extension ExerciseCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "setCVCell", for: indexPath) as! SetCollectionViewCell
        
        cell.repsLabel.text = String(setArray[indexPath.row])
        
        print("From Exercise Collection View Cell: ", setDoneArray)
        if setDoneArray[indexPath.row] == true {
            cell.setBackgroundView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
            cell.setForegroundView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
            cell.repsLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            cell.setBackgroundView.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.7725490196, blue: 0.7921568627, alpha: 1)
            cell.setForegroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.repsLabel.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        }
        
        if weightArray[indexPath.row] == 0 {
            cell.weightLabel.text = ""
        } else {
            cell.weightLabel.text = String(weightArray[indexPath.row])
        }
        
        return cell
    }
}
