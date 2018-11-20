//
//  MaxTrackingViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-16.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData


class MaxTrackingViewController: UIViewController {

    var message: Int?
    
    var timer = Timer()
    
    //Hide status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    var whoIsOnTop = 0
    
    
    
    @IBOutlet weak var singleUserView: UIView!
    @IBOutlet weak var dualUserView: UIView!
    
    
    @IBOutlet weak var currentExerciseTotalExerciseCollectionView: UICollectionView!
    @IBOutlet weak var currentExerciseNameLabel: UILabel!
    @IBOutlet weak var currentSetTotalSet: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var currentRep4Set: UILabel!
    
    
    @IBOutlet weak var singleUserViewButton: UIButton!
    @IBOutlet weak var dualUserButton: UIButton!
    
    var currentWorkoutUpdater = CurrentWorkoutUpdater() {
        didSet {
            
            print("MAX updater: ", currentWorkoutUpdater)
            if currentCountLabel != nil {
                DispatchQueue.main.async {
                    //Update UI
                    self.updateMaxiView(with: self.currentWorkoutUpdater)

                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Maxi Tracking VC Loaded")
        
        currentExerciseTotalExerciseCollectionView.delegate = self
        currentExerciseTotalExerciseCollectionView.dataSource = self
        currentExerciseTotalExerciseCollectionView.register(UINib.init(nibName: "MaxTVCCurrentExerciseCollectionVCell", bundle: nil), forCellWithReuseIdentifier: "MaxTVCCurrentExerciseCollectionVCell")
        
        
        updateMaxiView(with: currentWorkoutUpdater)
        
        //MARK: Testing Timer
//        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateRandomInt), userInfo: nil, repeats: true)
//        delegate.update(with: 2)
        
        applyButtonEffect(buttonOutlet: singleUserViewButton, imageName: "Users/whiteguy", flag: 1)
        applyButtonEffect(buttonOutlet: dualUserButton, imageName: "Glyphs/dual", flag: 0)
    }
    
    func updateMaxiView(with workoutData: CurrentWorkoutUpdater) -> Void {
        self.currentExerciseNameLabel.text = self.currentWorkoutUpdater.currentExerciseName
        self.currentSetTotalSet.text = String(self.currentWorkoutUpdater.currentSetIndex + 1) + "/" + String(self.currentWorkoutUpdater.totalSet4Exercise)
        self.currentCountLabel.text! = String(self.currentWorkoutUpdater.currentCount)
        self.currentRep4Set.text = "/" + String(self.currentWorkoutUpdater.currentRep4Set)
    }
    
    //MARK: Testing Function
    @objc func updateRandomInt() {
//        print("MAX: ", delegate.message)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func switchSingleUserViewButtonPressed(_ sender: UIButton) {
        if whoIsOnTop == 0 {
            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionCurlUp, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 1
        } else if whoIsOnTop == 1 {
            UIView.transition(from: singleUserView, to: singleUserView, duration: 1, options: [.transitionCurlDown, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 0
        } else {
            UIView.transition(from: dualUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 0
        }
        print("\(whoIsOnTop) is on top")
    }
    
    
    @IBAction func compareUserButtonPressed(_ sender: UIButton) {
        switch whoIsOnTop {
        case 2:
            UIView.transition(from: dualUserView, to: singleUserView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 0
        case 0:
            UIView.transition(from: singleUserView, to: dualUserView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 2
        case 1:
            UIView.transition(from: singleUserView, to: dualUserView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            whoIsOnTop = 2
        default:
            print("error")
        }
        print("\(whoIsOnTop) is on top")
    }
}


extension MaxTrackingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaxTVCCurrentExerciseCollectionVCell", for: indexPath) as! MaxTVCCurrentExerciseCollectionVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 70, height: 5)
        
        return cellSize
    }
}


extension MaxTrackingViewController {
    func applyButtonEffect(buttonOutlet:UIButton,imageName:String,flag:Int){
        let gradient:CAGradientLayer = CAGradientLayer()
        let colorTop = UIColor(red: 250.0/255.0, green: 208.0/255.0, blue: 97.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 246.0/255.0, green: 99.0/255.0, blue: 16.0/255.0, alpha: 1.0).cgColor
        
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: buttonOutlet.bounds.width , height: buttonOutlet.bounds.height))
        
        gradient.cornerRadius = buttonOutlet.bounds.width / 2
        
        buttonOutlet.layer.addSublayer(gradient)
        if(flag == 0)
        {
            let imageView:UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x: buttonOutlet.bounds.minX + 15, y: buttonOutlet.bounds.minY + 15), size: CGSize(width: buttonOutlet.bounds.width - 30, height: buttonOutlet.bounds.height - 30)))
            
            imageView.contentMode = .scaleAspectFit
            
            imageView.image = UIImage(named: imageName)
            buttonOutlet.addSubview(imageView)
        }
        else if flag == 1
        {
            
            let imageView:UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x: buttonOutlet.bounds.minX + 7, y: buttonOutlet.bounds.minY + 7), size: CGSize(width: buttonOutlet.bounds.width - 15, height: buttonOutlet.bounds.height - 15)))
            imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            
            imageView.image = UIImage(named: imageName)
            buttonOutlet.addSubview(imageView)
            
        }
    }
}
