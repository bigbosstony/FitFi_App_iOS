//
//  collectionView-In-CVC-Testing.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-08-13.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit

class ManualTrackingVC: UIViewController {

    @IBOutlet weak var exerciseCollectionView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var dateFormatter = DateFormatter()
    var timer = Timer()
    var name = "New"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseCollectionView.delegate = self
        exerciseCollectionView.dataSource = self
        
        //Set the section inset value
        let sectionInsetValue = self.view.frame.width / 2 - 125
        //Assign the value to uicollectionview
        let collectionViewLayout = exerciseCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 0, left: sectionInsetValue, bottom: 0, right: sectionInsetValue)
        collectionViewLayout?.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTitleView), userInfo: nil, repeats: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ManualTrackingVC {
    //TODO: Global Function
    @objc func updateTitleView() {
        dateFormatter.dateFormat = "EEEE MMM dd HH:mm a"
        let date = Date()
        let dateString = dateFormatter.string(from: date).uppercased()
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedStringKey.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8352941176, green: 0.3725490196, blue: 0.1215686275, alpha: 1)] as [NSAttributedStringKey : Any]
        
        let attributedString1 = NSMutableAttributedString(string: name.capitalized + "\n", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: dateString, attributes:attrs2)
        attributedString1.append(attributedString2)
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.attributedText = attributedString1
    }
}

extension ManualTrackingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testingRoutine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCVCell", for: indexPath) as! ExerciseCollectionViewCell
        cell.numberOfSets = testingRoutine[indexPath.row]["sets"] as? Int
        
        //Setuo Toolbar for Keypad
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 42))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        cell.weightLabel.inputAccessoryView = toolbar
        
        return cell
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
